<#PSScriptInfo

.VERSION 1.0.0

.GUID 50ceaf50-ab2f-44f4-8077-b918865e91f7

.AUTHOR diko@admins-little-helper.de

.COMPANYNAME

.COPYRIGHT (c) 2025 All rights reserved.

.TAGS Azure AI Translator

.LICENSEURI https://github.com/admins-little-helper/AzAiTranslate/blob/main/LICENSE

.PROJECTURI https://github.com/admins-little-helper/AzAiTranslate

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
    1.0.0
    Initial release
#>


<#

.DESCRIPTION
Return a list of languages supported by the Azure AI Translator REST API for text translation.

#>


function Get-AzAiSupportedLanguage {
    <#
    .SYNOPSIS
        Returns a list of languages supported by the Azure AI Translator REST API for text translation.

    .DESCRIPTION
        The 'Get-AzAiSupportedLanguage' returns a list of languages supported by the Azure AI Translator REST API for text translation.

    .PARAMETER Scope
        A comma-separated list of names defining the group of languages to return.
        Allowed group names are: translation, transliteration, and dictionary. If no scope is given, then all groups are returned

    .PARAMETER AcceptLanguage
        The language to use for user interface strings.

    .PARAMETER ServiceEndpoint
        The service endpoint to use. Can by any of "Global", "Americas", "AsiaPacific", "Europe", "Custom".

    .PARAMETER SubscriptionRegion
        The region of the multi-service or regional translator resource.

    .PARAMETER TextApiVersion
        The ApiVersion to use for text translation.

    .PARAMETER ClientTraceId
        A client-generated GUID to uniquely identify the request.

    .EXAMPLE
        Get-AzAiSupportedLanguage

        Returns a list of languages supported by the Azure AI Translator REST API for text translation.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     diko@admins-little-helper.de
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Get-AzAiSupportedLanguage.md
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False positive as rule does not scan child scopes')]
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Specify a list of names defining the group of languates to return. Allowed group names are: 'translation', 'transliteration', and 'dictionary'. If no scope is given, then all groups are returned.")]
        [ValidateSet("Dictionary", "Translation", "Transliteration")]
        [String[]]
        $Scope,

        [ArgumentCompleter({
                Param (
                    $Command,
                    $Parameter,
                    $WordToComplete,
                    $CommandAst,
                    $FakeBoundParameters
                )

                # Get the session variable content.
                $AzAiSessionTemp = Get-AzAiSessionSetting

                # Get the list of countries retrieved from the session variable.
                $CountryList = $AzAiSessionTemp.Bcp47LanguageCodes

                # Return a list of countries starting with the characters already typed for the parameter.
                $CountryList.where({ $_ -like "$WordToComplete*" })
            })]
        [Parameter(HelpMessage = "Specify the language to use for user interface strings. Provide a BCP 47 language tag (for example 'en' or 'de'). Defaults to English.")]
        [String]
        $AcceptLanguage,

        [Parameter(HelpMessage = "Specify the service endpoint to connect to.")]
        [ValidateSet("Global", "Americas", "AsiaPacific", "Europe", "Custom")]
        [String]
        $ServiceEndpoint = $Script:AzAiSession.ServiceEndpointToUse,

        [Parameter(HelpMessage = "Specify the Azure Region to use.")]
        [String]
        $AzureRegion = $Script:AzAiSession.SubscriptionRegionToUse,

        [Parameter(HelpMessage = "Specify the API version to use.")]
        [String]
        $TextApiVersion = $Script:AzAiSession.TextApiVersion,

        [Parameter(HelpMessage = "Specify a client generated GUID to uniquely identify the request.")]
        [Guid]
        $ClientTraceId,

        [Parameter(HelpMessage = "If specified, the returned value includes the unmodified query result from the REST api call.")]
        [Switch]
        $ReturnRawResult
    )

    # Prepare the base Uri based on the selected service endpoint.
    $ServiceEndpointUri = Get-AzAiServiceEndpointUri -ServiceEndpoint $ServiceEndpoint
    $Uri = "$($ServiceEndpointUri)/languages?api-version=$TextApiVersion"

    # Add parameter 'scope' to query string, if it was specifed as parameter.
    if (-not([string]::IsNullOrEmpty($Scope))) {
        # Make sure each specified value for parameter 'Scope' is there only once.
        $Scope = $Scope | Select-Object -Unique
        # Prepare the Uri to call by appending the specified scopes as comma separated list to the base uri.
        $Uri = $Uri + "&scope=$($Scope.ToLower() -join ",")"
    }

    # Defining the parameters for the Invoke-WebRequest cmdlet.
    $InvokeWebRequestParams = @{
        Uri     = $Uri
        Method  = "Get"
        Headers = @{}
    }

    # Check if a value was specified for parameter 'AcceptLanguage'.
    if (-not([string]::IsNullOrEmpty($AcceptLanguage))) {
        Write-Verbose -Message "Setting request header parameter 'Accept-Language' to value [$AcceptLanguage]"
        $InvokeWebRequestParams.Headers.'Accept-Language' = $AcceptLanguage
    }

    # Check if a a specific Azure Region was specified.
    if (-not([string]::IsNullOrEmpty($AzureRegion))) {
        Write-Verbose -Message "Setting request header parameter 'Ocp-Apim-Subscription-Region' to value [$($AzureRegion)]"
        $InvokeWebRequestParams.Headers.'Ocp-Apim-Subscription-Region' = $AzureRegion
    }

    # Check if a value was specified for parameter 'ClientTraceId'.
    if ($PSBoundParameters.Keys -contains 'ClientTraceId') {
        Write-Verbose -Message "Setting request header parameter 'X-ClientTraceId' to value [$ClientTraceId]"
        $InvokeWebRequestParams.Headers.'X-ClientTraceId' = $ClientTraceId
    }

    try {
        # Try calling the Uri.
        Write-Verbose -Message "Calling URI [$Uri]."
        $RawResult = Invoke-WebRequest @InvokeWebRequestParams
        $RawResultObject = $RawResult.Content | ConvertFrom-Json

        if ($ReturnRawResult.IsPresent) {
            # Return the raw result from the web request, if specified by parameter 'ReturnRawResult'.
            $Result = $RawResult
        }
        else {
            # Convert the result to a custom format and return that.

            # If the result contains an object for 'dictionary', take it's values and prepare a custom object.
            if ($RawResultObject.PSObject.Properties.match('dictionary').Count) {
                $Dictionary = foreach ($Item in $RawResultObject.dictionary.PSObject.Properties) {
                    $AzAiSupportedLanguage = [PSCustomObject]@{
                        Code           = $Item.Name
                        Name           = $Item.Value.name
                        NativeName     = $Item.Value.nativeName
                        Directionality = $Item.Value.dir
                        Translations   = $Item.Value.translations
                    }
                    $AzAiSupportedLanguage.PSObject.TypeNames.Insert(0, "AzAiSupportedLanguageDictionary")
                    $AzAiSupportedLanguage
                }
            }

            # If the result contains an object for 'translation', take it's values and prepare a custom object.
            if ($RawResultObject.PSObject.Properties.match('translation').Count) {
                $Translation = foreach ($Item in $RawResultObject.translation.PSObject.Properties) {
                    $AzAiSupportedLanguage = [PSCustomObject]@{
                        Code           = $Item.Name
                        Name           = $Item.Value.name
                        NativeName     = $Item.Value.nativeName
                        Directionality = $Item.Value.dir
                    }
                    $AzAiSupportedLanguage.PSObject.TypeNames.Insert(0, "AzAiSupportedLanguageTranslation")
                    $AzAiSupportedLanguage
                }
            }

            # If the result contains an object for 'transliteration', take it's values and prepare a custom object.
            if ($RawResultObject.PSObject.Properties.match('transliteration').Count) {
                $Transliteration = foreach ($Item in $RawResultObject.transliteration.PSObject.Properties) {
                    $AzAiSupportedLanguage = [PSCustomObject]@{
                        Code       = $Item.Name
                        Name       = $Item.Value.name
                        NativeName = $Item.Value.nativeName
                        Scripts    = $Item.Value.scripts
                    }
                    $AzAiSupportedLanguage.PSObject.TypeNames.Insert(0, "AzAiSupportedLanguageTransliteration")
                    $AzAiSupportedLanguage
                }
            }

            # Combine the results for each object type and some additonal information from the web request result.
            $Result = [PSCustomObject]@{
                Dictionary      = $Dictionary
                Translation     = $Translation
                Transliteration = $Transliteration
                RawResult       = $null
                ETag            = $RawResult.Headers.ETag
                RequestId       = $RawResult.Headers.'X-RequestId'
            }

            # Add the custom type name for proper formatting the output.
            $Result.PSObject.TypeNames.Insert(0, "AzAiSupportedLanguageResult")
        }

        # Return the end result.
        $Result
    }
    catch {
        $_
    }
}