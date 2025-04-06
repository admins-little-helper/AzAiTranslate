<#PSScriptInfo

.VERSION 1.0.0

.GUID ff68f6f6-8f51-48b2-96a2-3755b889eb3d

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
Set session variables for AzAiTranslate.

#>


function Set-AzAiSessionSetting {
    <#
    .SYNOPSIS
        Set settings for AzAiTranslate module functions, like the subscription key.

    .DESCRIPTION
        The 'Set-AzAiSessionSetting' function allows to et settings for AzAiTranslate module functions, like the subscription key.

    .PARAMETER SubsriptionKey
        The subscript key (API key) of your Azure AI Translator subscription.

    .PARAMETER ServiceEndpoint
        The service endpoint to use. Can by any of "Global", "Americas", "AsiaPacific", "Europe", "Custom".

    .PARAMETER CustomServiceEndpointUri
        The URI for the custom service endpoint.

    .PARAMETER SubscriptionRegion
        The region of the multi-service or regional translator resource.

    .EXAMPLE
        Set-AzAiSessionSetting -SubsriptionKey "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

        Set the SubscriptionKey that will be used by all functions in the AzAiTranslate module, so you don't need to specify it separatly in each function call.

    .EXAMPLE
        Set-AzAiSessionSetting -ServiceEndpoint Europe -CustomServiceEndpointUri 'https://my-custom-service-endpoint.cognitiveservices.azure.com'

        Set the service endpoint to Europe and the service endpoint URI for the custom service endpoitn to the custom endpoint URI 'https://my-custom-service-endpoint.cognitiveservices.azure.com'.

    .EXAMPLE
        Set-AzAiSessionSetting -ServiceEndpoint Custom -SubscriptionRegion germanywestcentral

        Set the service endpoint to Europe and the subsription region to 'GermanyWestCentral'.

    .INPUTS
        Nothing

    .OUTPUTS
        Nothing

    .NOTES
        Author:     diko@admins-little-helper.de
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Set-AzAiSessionSetting.md
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False positive as rule does not scan child scopes')]
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param (
        [Parameter(HelpMessage = "Specify the Subscription Key (API key) for Azure AI Translator.")]
        [String]
        $SubsriptionKey,

        [Parameter(HelpMessage = "Specify the service endpoint to use.")]
        [ValidateSet("Global", "Americas", "AsiaPacific", "Europe", "Custom")]
        [String]
        $ServiceEndpoint = "Global",

        [Parameter(Mandatory = $true, ParameterSetName = "CustomEndpoint", HelpMessage = "Specify the URI for the custom service endpoint.")]
        [Uri]
        $CustomServiceEndpointUri,

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
        $SubscriptionRegion,

        [Parameter(HelpMessage = "Specify the API version to use for text translation.")]
        [System.String]
        $TextApiVersion = $Script:AzAiSession.TextApiVersion,

        [Parameter(HelpMessage = "Specify the API version to use for document translation.")]
        [System.String]
        $DocumentApiVersion = $Script:AzAiSession.DocumentApiVersion
    )

    # Set the subscriction key.
    if ($PSBoundParameters.Keys.contains('SubsriptionKey')) {
        # Mask the subscription key in the verbose output and only show the last 5 characters in clear text.
        $SubsriptionKeyMasked = ('*' * ($SubsriptionKey.Length - 5)) + ($SubsriptionKey[-5..-1] -join '')
        Write-Verbose -Message "Setting subscription key to [$($SubsriptionKeyMasked)]."
        if ($PSCmdlet.ShouldProcess("Setting subscription key.")) {
            $Script:AzAiSession.Authentication.OcpApimSubscriptionKey = $SubsriptionKey
        }
    }

    # Set the service endpoint to use.
    if ($PSBoundParameters.Keys.contains('ServiceEndpoint')) {
        if ($ServiceEndpoint -eq "Custom") {
            # Check if a custom service endpoint URI was specified as well by parameter or previously.
            if ([string]::IsNullOrEmpty($CustomServiceEndpointUri) -and [string]::IsNullOrEmpty($Script:AzAiSession.ServiceEndpoints.Custom)) {
                Write-Warning -Message "Can not set ServiceEndpoint to [Custom] because no URI was specified for the custom endpoint. Use parameter 'CustomServiceEndpointUri' to set a URI for the custom service endpoint."
            }
            else {
                Write-Verbose -Message "Change service endpoint from value [$($Script:AzAiSession.ServiceEndpointToUse)] to [$ServiceEndpoint]."
                if ($PSCmdlet.ShouldProcess("Setting service endpoint.")) {
                    $Script:AzAiSession.ServiceEndpointToUse = $ServiceEndpoint
                }
            }

        }
        else {
            Write-Verbose -Message "Change service endpoint from value [$($Script:AzAiSession.ServiceEndpointToUse)] to [$ServiceEndpoint]."
            if ($PSCmdlet.ShouldProcess("Setting service endpoint.")) {
                $Script:AzAiSession.ServiceEndpointToUse = $ServiceEndpoint
            }
        }
        Write-Verbose -Message "Service Endpoint URI is [$($Script:AzAiSession.ServiceEndpoints.$ServiceEndpoint)]."
    }

    # Set the URI for the custom service endpoint, that is used for documentation translation.
    if ($PSBoundParameters.Keys.contains('CustomServiceEndpointUri')) {
        # Set the specified custom URI in the session variable.
        Write-Verbose -Message "Change custom service endpoint Uri from value [$($Script:AzAiSession.ServiceEndpoints.Custom)] to [$CustomServiceEndpointUri]."
        if ($PSCmdlet.ShouldProcess("Setting custom service endpoint URI.")) {
            $Script:AzAiSession.ServiceEndpoints.Custom = $CustomServiceEndpointUri
        }
    }

    # Set the service endpoint region value. This is the name of the Azure datacenter.
    if ($PSBoundParameters.Keys.contains('SubscriptionRegion')) {
        Write-Verbose -Message "Change subscription region from value [$($Script:AzAiSession.SubscriptionRegionToUse)] to [$SubscriptionRegion]."
        if ($PSCmdlet.ShouldProcess("Setting subscription region.")) {
            $Script:AzAiSession.SubscriptionRegionToUse = $SubscriptionRegion
        }
    }

    # Set the API version for text translation.
    if ($PSBoundParameters.Keys.contains('TextApiVersion')) {
        Write-Verbose -Message "Change text translation API version [$($Script:AzAiSession.TextApiVersion)] to [$TextApiVersion]."
        if ($PSCmdlet.ShouldProcess("Setting text translation API version.")) {
            $Script:AzAiSession.TextApiVersion = $TextApiVersion
        }
    }

    # Set the API version for document translation.
    if ($PSBoundParameters.Keys.contains('DocumentApiVersion')) {
        Write-Verbose -Message "Change document translation API version [$($Script:AzAiSession.DocumentApiVersion)] to [$DocumentApiVersion]."
        if ($PSCmdlet.ShouldProcess("Setting document translation API version.")) {
            $Script:AzAiSession.DocumentApiVersion = $DocumentApiVersion
        }
    }
}