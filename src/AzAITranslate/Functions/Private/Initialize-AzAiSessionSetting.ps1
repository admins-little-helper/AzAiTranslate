<#PSScriptInfo

.VERSION 1.0.0

.GUID 9939a4f7-d28c-4893-a61d-b97c6b1ed399

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
Initialize the AzAiTranslate session variable. This function is called on module import (without the 'Force' parameter).

#>


function Initialize-AzAiSessionSetting {
    <#
    .SYNOPSIS
        Initializes the AzAiTranslate session variable with default values.

    .DESCRIPTION
        The 'Initialize-AzAiSessionSetting' initializes the AzAiTranslate session variable with default values.

    .PARAMETER Force
        If specified, the list of Azure Regions will be downloaded even if it has been downloaded already previously.

    .EXAMPLE
        Initialize-AzAiSessionSetting

        Initialize the AzAiSession variable and set default values for the AzAiTranslate functions.

    .EXAMPLE
        Initialize-AzAiSessionSetting -Force

        Initialize the AzAiSession variable and set default values for the AzAiTranslate functions.
        The list of Azure Regions will be downlaoded again from "https://datacenters.microsoft.com/globe/data/geo/regions.json" instead of re-using a previously download list.

    .INPUTS
        Nothing

    .OUTPUTS
        Nothing

    .NOTES
        Author:     diko@admins-little-helper.de
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Get-AzAiServiceEndpointUri.md
    #>
    [CmdletBinding()]
    param (
        [Switch]
        $Force
    )

    try {
        # Try to get a list of Azure regions. The Region ID can be used in 'Ocp-Apim-Subscription-Region'
        if ($null -eq $AzureRegionInformation -or $Force.IsPresent) {
            # Get a list of Azure Regions.
            $AzureRegionInformation = Invoke-RestMethod -Uri "https://datacenters.microsoft.com/globe/data/geo/regions.json"
            $AzureRegionInformation = $AzureRegionInformation.Id | Sort-Object
        }
    }
    catch {
        # Use this hardcoded list of Azure Region IDs as fallback in case it's not possible to retrieve the current list from the URL.
        # Azure Region IDs returned by 'Invoke-RestMethod -Uri "https://datacenters.microsoft.com/globe/data/geo/regions.json"' as of 2025-12-14.
        $AzureRegionInformation = @(
            "australiacentral",
            "australiaeast",
            "australiasoutheast",
            "austriaeast",
            "belgiumcentral",
            "brazilsouth",
            "canadacentral",
            "canadaeast",
            "centralindia",
            "centralus",
            "chilecentral",
            "chinaeast",
            "chinaeast2",
            "chinanorth",
            "chinanorth2",
            "chinanorth3",
            "denmarkeast",
            "eastasia",
            "eastus",
            "eastus2",
            "eastus3",
            "finlandcentral",
            "francecentral",
            "germanywestcentral",
            "greececentral",
            "indonesiacentral",
            "israelcentral",
            "italynorth",
            "japaneast",
            "japanwest",
            "koreacentral",
            "malaysiawest",
            "mexicocentral",
            "newzealandnorth",
            "northcentralus",
            "northeurope",
            "norwayeast",
            "polandcentral",
            "qatarcentral",
            "saudiarabiaeast",
            "southafricanorth",
            "southcentralindia",
            "southcentralus",
            "southeastasia",
            "southindia",
            "spaincentral",
            "swedencentral",
            "switzerlandnorth",
            "taiwannorth",
            "uaenorth",
            "uksouth",
            "ukwest",
            "westcentralus",
            "westeurope",
            "westus",
            "westus2",
            "westus3"
        )
    }

    Write-Verbose -Message "Initializing AzAiTranslate session variable with default values. This will reset any previously set values."

    # Set default values for the script environment.
    $Script:AzAiSession = [PSCustomObject]@{
        AzureRegions            = $AzureRegionInformation
        # Service Endpoints supported by Microsoft Translator REST API as of November 2025.
        # https://learn.microsoft.com/en-us/azure/ai-services/translator/reference/v3-0-reference#base-urls
        ServiceEndpoints        = [ordered]@{
            Global      = "https://api.cognitive.microsofttranslator.com"
            Americas    = "https://api-nam.cognitive.microsofttranslator.com"
            AsiaPacific = "https://api-apc.cognitive.microsofttranslator.com"
            Europe      = "https://api-eur.cognitive.microsofttranslator.com"
            # Set the global endpoint URI as default value for the custom endpoint.
            Custom      = "https://api.cognitive.microsofttranslator.com"
        }
        # Simply use the language codes returned by Get-Culture on the local system.
        Bcp47LanguageCodes      = (Get-Culture -ListAvailable).Name | Where-Object { $null -ne $_ -and $_ -ne '' }
        SubscriptionRegionToUse = $null
        ServiceEndpointToUse    = 'Global'
        TextApiVersion          = "3.0"
        DocumentApiVersion      = "2024-05-01"
        Authentication          = [PSCustomObject]@{
            # The sbuscription key to use for authentication.
            OcpApimSubscriptionKey    = $null
            # The Azure region in which the transltor resource resides in.
            OcpApimSubscriptionRegion = $null
            # A bearer token to use instead of the subscription key.
            Authorization             = $null
        }
    }
}