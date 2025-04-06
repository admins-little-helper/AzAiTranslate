<#PSScriptInfo

.VERSION 1.0.0

.GUID 6c5007d3-1ac6-422f-b86c-b0316e151677

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
Detect language of the specified InputString.

#>


function Invoke-AzAiDetectLanguage {
    <#
    .SYNOPSIS
        Detects language of the specified InputString.

    .DESCRIPTION
        The 'Invoke-AzAiDetectLanguage' detects language of the specified InputString.

    .PARAMETER InputString
        The string to detect language for.

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
        Invoke-AzAiDetectLanguage -InputString "This is a sample input string."

        This will try to detect the language of the input string and return the following information.

    .EXAMPLE
        Invoke-AzAiDetectLanguage -InputString (Get-Content -Path C:\Temp\testlanguagedetect.txt)

        The Get-Content will read the 'MyDocument.txt' file, line by line. 'Invoke-AzAiDetectLanguage' will then call the Azure AI Translator API to detect the language of each line.

    .EXAMPLE
        "This example shows that the function also supports input from pipeline." | Invoke-AzAiDetectLanguage

        It is possible to pipe a string to the 'Invoke-AzAiDetectLanguage' function.

    .INPUTS
        System.String

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     diko@admins-little-helper.de
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Invoke-AzAiDetectLanguage.md
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False positive as rule does not scan child scopes')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The string to detect language for.")]
        [String[]]
        $InputString,

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
        $Uri = "$($ServiceEndpointUri)/detect?api-version=$TextApiVersion"

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
            $Result.Content | ConvertFrom-Json
        }
        catch {
            $_
        }
    }
}
