<#PSScriptInfo

.VERSION 1.0.0

.GUID ba313c94-80dc-4e17-bab0-ca4dda21b459

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
Return a list of glossary formats supported for document translation.

#>


function Get-AzAiSupportedGlossaryFormat {
    <#
    .SYNOPSIS
        Returns a list of glossary formats supported for document translation.

    .DESCRIPTION
        The 'Get-AzAiSupportedGlossaryFormat' returns a list of glossary formats supported for document translation.

    .PARAMETER ServiceEndpoint
        The service endpoint to use. Can by any of "Global", "Americas", "AsiaPacific", "Europe", "Custom".

    .PARAMETER SubsriptionKey
        The subscript key (API key) of your Azure AI Translator subscription.

    .PARAMETER SubscriptionRegion
        The region of the multi-service or regional translator resource.

    .PARAMETER DocumentApiVersion
        The ApiVersion to use for document translation.

    .EXAMPLE
        Get-AzAiSupportedGlossaryFormat

        Returns a list of glossary formats supported for document translation.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     diko@admins-little-helper.de
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Get-AzAiSupportedGlossaryFormat.md
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False positive as rule does not scan child scopes')]
    [CmdletBinding()]
    param(
        # All API requests to the Document Translation feature require a custom domain endpoint that is located on your resource overview page in the Azure portal.
        # https://learn.microsoft.com/en-us/azure/ai-services/translator/document-translation/reference/get-supported-document-formats#request-url
        [Parameter(HelpMessage = "Specify the service endpoint to connect to.")]
        [ValidateSet("Custom")]
        [String]
        $ServiceEndpoint = "Custom",

        [Parameter(Mandatory = $false, HelpMessage = "Specifies the subscription key for authentication.")]
        [System.String]
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
        [System.String]
        $SubscriptionRegion = $Script:AzAiSession.SubscriptionRegionToUse,

        [Parameter(HelpMessage = "Specify the API version to use for document translation.")]
        [System.String]
        $DocumentApiVersion = $Script:AzAiSession.DocumentApiVersion
    )

    # Prepare the base Uri based on the selected service endpoint.
    $ServiceEndpointUri = Get-AzAiServiceEndpointUri -ServiceEndpoint $ServiceEndpoint
    $Uri = "$($ServiceEndpointUri)translator/document/formats?api-version=$DocumentApiVersion&type=glossary"

    # Defining the parameters for the Invoke-WebRequest cmdlet.
    $InvokeWebRequestParams = @{
        Uri         = $Uri
        Method      = 'Get'
        ContentType = 'appliation/json'
        Headers     = @{
            'Ocp-Apim-Subscription-Key' = $SubsriptionKey
        }
    }

    # Check if a specific Azure Region was specified.
    if (-not([string]::IsNullOrEmpty($SubscriptionRegion))) {
        Write-Verbose -Message "Setting request header parameter 'Ocp-Apim-Subscription-Region' to value [$($SubscriptionRegion)]"
        $InvokeWebRequestParams.Headers.'Ocp-Apim-Subscription-Region' = $SubscriptionRegion
    }

    try {
        # Try calling the Uri.
        Write-Verbose -Message "Calling URI [$Uri]."
        $RawResult = Invoke-WebRequest @InvokeWebRequestParams

        # Convert the content to type 'PSCustomObject'.
        $RawResultObject = $RawResult.Content | ConvertFrom-Json

        # Prepare a custom object based on the retured values.
        if ($RawResultObject.PSObject.Properties.match('value').Count) {
            $Result = foreach ($Item in $RawResultObject.value) {
                $AzAiSupportedGlossaryFormat = [PSCustomObject]@{
                    Format         = $Item.Format
                    FileExtensions = $Item.FileExtensions
                    ContentTypes   = $Item.ContentTypes
                    Defaultversion = $Item.Defaultversion
                    Versions       = $Item.Versions
                    Type           = $Item.Type
                }
                $AzAiSupportedGlossaryFormat.PSObject.TypeNames.Insert(0, "AzAiSupportedGlossaryFormat")
                $AzAiSupportedGlossaryFormat
            }
        }

        # Return the end result.
        $Result
    }
    catch {
        $_
    }
}