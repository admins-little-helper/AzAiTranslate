<#PSScriptInfo

.VERSION 1.0.0

.GUID a3585107-b646-4753-a3a5-393498ac8dea

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
Translate text from one language to another using Azure AI Translator REST API.

#>


function Invoke-AzAiTranslateText {
    <#
    .SYNOPSIS
        Translate text from one language to another using Azure AI Translator REST API.

    .DESCRIPTION
        The 'Invoke-AzAiTranslateText' translates text from one language to another using Azure AI Translator REST API.

    .PARAMETER InputString
        The string to translate.

    .PARAMETER To
        The target language (for example 'en').

    .PARAMETER From
        The source language (for example 'de').

    .PARAMETER SuggestedFrom
        Specifies a fallback language if the language of the input text can't be identified. Language autodetection is applied when the from parameter is omitted. If detection fails, the suggestedFrom language is assumed.

    .PARAMETER ProfanityAction
        Specifies how profanities should be treated in translations. Possible values are: NoAction (default), Marked, or Deleted.

    .PARAMETER ProfanityMarker
        Specifies how profanities should be marked in translations. Possible values are: Asterisk (default) or Tag.

    .PARAMETER IncludeAlignment
        Specifies whether to include alignment projection from source text to translated text.

    .PARAMETER IncludeSentenceLength
        Specifies whether to include sentence boundaries for the input text and the translated text.

    .PARAMETER TextType
        Specifies the text type of the input string (either plain text or html).

    .PARAMETER ServiceEndpoint
        The service endpoint to use. Can by any of "Global", "Americas", "AsiaPacific", "Europe".

    .PARAMETER SubsriptionKey
        The subscript key (API key) of your Azure AI Translator subscription.

    .PARAMETER SubscriptionRegion
        The region of the multi-service or regional translator resource.

    .PARAMETER TextApiVersion
        The ApiVersion to use for text translation.

    .PARAMETER ClientTraceId
        A client-generated GUID to uniquely identify the request.

    .EXAMPLE
        Invoke-AzAiTranslateText -InputString "This is an example." -From 'en' -To 'de'

        translations
        ------------
        {@{text=Dies ist ein Beispiel.; to=de}}

        This will translate the specified input string from English to German.

    .EXAMPLE
        Invoke-AzAiTranslateText -InputString "This is a damn good example." -From 'en' -To 'de' -ProfanityAction Marked

        translations
        ------------
        {@{text=Das ist ein *** gutes Beispiel.; to=de}}

        This will translate the specified input string from English to German. The word 'damn' will be marked with ssterisk in the resulting translation.

    .INPUTS
        System.String

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     diko@admins-little-helper.de
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Invoke-AzAiTranslateText.md
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False positive as rule does not scan child scopes')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The text to translate.")]
        [String[]]
        $InputString,

        [Parameter(Mandatory = $true, HelpMessage = "Specifies the target language.")]
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

                # Get the list of language codes retrieved from the session variable.
                $TargetLanguageCodes = $AzAiSessionTemp.Bcp47LanguageCodes

                # Return a list of language codes starting with the characters already typed for the parameter.
                $TargetLanguageCodes.where({ $_ -like "$WordToComplete*" })
            })]
        [String[]]
        $To,

        [Parameter(HelpMessage = "Specify the source language. If ommited language autodetections is applied.")]
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

                # Get the list of language codes retrieved from the session variable.
                $TargetLanguageCodes = $AzAiSessionTemp.Bcp47LanguageCodes

                # Return a list of language codes starting with the characters already typed for the parameter.
                $TargetLanguageCodes.where({ $_ -like "$WordToComplete*" })
            })]
        [String]
        $From,

        [Parameter(HelpMessage = "Specifies a fallback language if the language of the input text can't be identified. Language autodetection is applied when the from parameter is omitted. If detection fails, the suggestedFrom language is assumed.")]
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

                # Get the list of language codes retrieved from the session variable.
                $TargetLanguageCodes = $AzAiSessionTemp.Bcp47LanguageCodes

                # Return a list of language codes starting with the characters already typed for the parameter.
                $TargetLanguageCodes.where({ $_ -like "$WordToComplete*" })
            })]
        [String]
        $SuggestedFrom,

        [Parameter(HelpMessage = "Specifies how profanities should be treated in translations. Possible values are: NoAction (default), Marked, or Deleted.")]
        [ValidateSet("NoAction", "Marked", "Deleted")]
        [String]
        $ProfanityAction = "NoAction",

        [Parameter(HelpMessage = "Specifies how profanities should be marked in translations. Possible values are: Asterisk (default) or Tag.")]
        [ValidateSet("Asterisk", "Tag")]
        [String]
        $ProfanityMarker = "Asterisk",

        [Parameter(HelpMessage = "Specifies whether to include alignment projection from source text to translated text.")]
        [Switch]
        $IncludeAlignment,

        [Parameter(HelpMessage = "Specifies whether to include sentence boundaries for the input text and the translated text.")]
        [Switch]
        $IncludeSentenceLength,

        [Parameter(HelpMessage = "Specifies the text type of the input string (either plain text or html).")]
        [ValidateSet("Plain", "HTML")]
        [String]
        $TextType = "Plain",

        [Parameter(HelpMessage = "Specify the service endpoint to connect to.")]
        [ValidateSet("Global", "Americas", "AsiaPacific", "Europe")]
        [String]
        $ServiceEndpoint = $Script:AzAiSession.ServiceEndpointToUse,

        [Parameter(HelpMessage = "Specifies the subscription key for authentication.")]
        [String]
        $SubsriptionKey = $Script:AzAiSession.Authentication.OcpApimSubscriptionKey,

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
                $AzureRegions = $AzAiSessionTemp.AzureRegions

                # Return a list of countries starting with the characters already typed for the parameter.
                $AzureRegions.where({ $_ -like "$WordToComplete*" })
            })]
        [Parameter(HelpMessage = "Specify the region of the multi-service or regional translator resource.")]
        [String]
        $SubscriptionRegion = $Script:AzAiSession.SubscriptionRegionToUse,

        [Parameter(HelpMessage = "Specify the API version to use. Version 3.0 is currently the only supported version.")]
        [String]
        $TextApiVersion = $Script:AzAiSession.TextApiVersion,

        [Parameter(HelpMessage = "Specify a client generated GUID to uniquely identify the request.")]
        [Guid]
        $ClientTraceId
    )

    begin {
        if ([string]::IsNullOrEmpty($SubsriptionKey)) {
            # Throw an error if there is no subscription key.
            throw "No subscription key specified. Specify an subscription key either by using the parameter 'SubscriptionKey' or by setting a subscription key in the session variable with 'Set-AzAiSessionSetting -SubscriptionKey <key>'."
        }

        # Prepare the base Uri based on the selected service endpoint and ApiVersion.
        $ServiceEndpointUri = Get-AzAiServiceEndpointUri -ServiceEndpoint $ServiceEndpoint
        $Uri = "$($ServiceEndpointUri)/translate?api-version=$TextApiVersion"

        # Add parameter 'from' to query string in case it was specified.
        if (-not [string]::IsNullOrEmpty($From)) {
            $Uri = "$($Uri)&from=$($From)"
        }

        # Add parameter 'to' to query string.
        if (-not [string]::IsNullOrEmpty($To)) {
            foreach ($ToLanguage in $To) {
                $Uri = "$($Uri)&to=$($ToLanguage)"
            }
        }

        # Add parameter 'suggestedFrom' to query string in case it was specified.
        if ($PSBoundParameters.Keys -contains 'SuggestedFrom') {
            if (-not [string]::IsNullOrEmpty($SuggestedFrom)) {
                $Uri = "$($Uri)&suggestedFrom=$($SuggestedFrom)"
            }
        }

        # Add parameter 'profanityAction' to query string in case it was specified.
        if ($PSBoundParameters.Keys -contains 'ProfanityAction') {
            if (-not [string]::IsNullOrEmpty($ProfanityAction)) {
                $Uri = "$($Uri)&profanityAction=$($ProfanityAction)"
            }
        }

        # Add parameter 'profanityMarker' to query string in case it was specified.
        if ($PSBoundParameters.Keys -contains 'ProfanityMarker') {
            if (-not [string]::IsNullOrEmpty($ProfanityMarker)) {
                $Uri = "$($Uri)&profanityMarker=$($ProfanityMarker)"
            }
        }

        # Add parameter 'includeAlignment' in case it was specified.
        if ($IncludeAlignment.IsPresent) {
            $Uri = "$($Uri)&includeAlignment=true"
        }

        # Add parameter 'includeSentenceLength' in case it was specified.
        if ($IncludeSentenceLength.IsPresent) {
            $Uri = "$($Uri)&includeSentenceLength=true"
        }

        # Add parameter 'textType' to query string in case it was specified.
        if ($PSBoundParameters.Keys -contains 'TextType') {
            if (-not [string]::IsNullOrEmpty($TextType)) {
                $Uri = "$($Uri)&textType=$($TextType)"
            }
        }

        $InvokeWebRequestParams = @{
            Uri         = $Uri
            Method      = "Post"
            Headers     = @{
                'Content-type'              = 'application/json; charset=utf-8'
                'Ocp-Apim-Subscription-Key' = $SubsriptionKey
            }
            Body        = ""
            ErrorAction = "Stop"
        }

        # Check if a specific Azure Region was specified.
        if (-not([string]::IsNullOrEmpty($SubscriptionRegion))) {
            Write-Verbose -Message "Setting request header parameter 'Ocp-Apim-Subscription-Region' to value [$($SubscriptionRegion)]"
            $InvokeWebRequestParams.Headers.'Ocp-Apim-Subscription-Region' = $SubscriptionRegion
        }

        # Check if a value was specified for parameter 'ClientTraceId'.
        if ($PSBoundParameters.Keys -contains 'ClientTraceId') {
            Write-Verbose -Message "Setting request header parameter 'X-ClientTraceId' to value [$ClientTraceId]"
            $InvokeWebRequestParams.Headers.'X-ClientTraceId' = $ClientTraceId
        }
    }

    process {
        # Prepare the source text parameter for the query.
        [Array]$InputStringObjects = foreach ($IntputStringItem in $InputString) {
            [PSCustomObject]@{
                Text = $IntputStringItem
            }
        }

        # Convert the array of PSCustomObjects to JSON.
        $Body = $InputStringObjects | ConvertTo-Json

        # In case the InputStringObjects array has only one (1) element, the resulting JSON string will show only an object, not an array of one object.
        # The API expects always a JSON array, so make sure that this is the case.
        if ($Body.StartsWith('{')) { $Body = "[$Body]" }
        $InvokeWebRequestParams.Body = $Body

        try {
            Write-Verbose -Message "Calling URI [$Uri]."
            $Result = Invoke-WebRequest @InvokeWebRequestParams

            # Return the result
            $Translation = $Result.Content | ConvertFrom-Json

            $TranslationResult = foreach ($TranslatedLanguage in $Translation.translations) {
                $TR = [PSCustomObject]@{
                    Text                 = $TranslatedLanguage.text
                    Language             = $TranslatedLanguage.to
                    Alignment            = $null
                    SourceSentenceLength = $null
                    TransSentenceLength  = $null
                }
                if ($TranslatedLanguage.PSObject.Properties.Name -contains "alignment") {
                    $TR.Alignment = $TranslatedLanguage.alignment.proj
                }
                if ($TranslatedLanguage.PSObject.Properties.Name -contains "sentLen") {
                    $TR.SourceSentenceLength = $TranslatedLanguage.sentLen.srcSentLen
                    $TR.SourceSentenceLength = $TranslatedLanguage.sentLen.transSentLen
                }
                $TR.PSTypeNames.Add("AzAiTextTranslation")
                $TR
            }
            $TranslationResult
        }
        catch {
            $_
        }
    }
}
