# AzAiTranslate

## Table of contents

- [AzAiTranslate](#azaitranslate)
  - [Table of contents](#table-of-contents)
  - [About](#about)
  - [Copyright notice](#copyright-notice)
  - [Release Notes](#release-notes)
  - [Module help](#module-help)
  - [How to install the module](#how-to-install-the-module)
  - [How to update the module](#how-to-update-the-module)
  - [How to uninstall the module](#how-to-uninstall-the-module)
  - [Examples](#examples)
    - [Example 1 - Translate a plain text string](#example-1---translate-a-plain-text-string)
    - [Example 2 - Translate a plain text file](#example-2---translate-a-plain-text-file)
    - [Example 3 - Set session variable values](#example-3---set-session-variable-values)
    - [Example 4 - Return the session variable object](#example-4---return-the-session-variable-object)
    - [Example 5 - Return a list of supported languages by Azure AI for all scopes](#example-5---return-a-list-of-supported-languages-by-azure-ai-for-all-scopes)
      - [Example 5a - Return a list of supported languages for translation](#example-5a---return-a-list-of-supported-languages-for-translation)
      - [Example 5b - Return a list of supported languages for dictionary lookup](#example-5b---return-a-list-of-supported-languages-for-dictionary-lookup)
  - [Appendix A - How to setup and configure an Azure AI Translator resource](#appendix-a---how-to-setup-and-configure-an-azure-ai-translator-resource)

## About

AzAiTranslate is a PowerShell Module that uses Microsoft's Azure AI Translator REST API for text and document translation. It supports translating text (plain text or html), language detection, dictionary lookup, text transliteration and single document translation. This PowerShell module does not support batch document translation.
Azure AI Tranlsator requires an Azure subscription. It is possible to get a free Azure subscription and add a Azure AI Translator resource in the free plan. The free plan only allows text translation. For document translation, a paid subscription tier is required (as of December 2025).

For more details about Microsoft Azure AI Translator, please review the [documentation]([documentation](https://learn.microsoft.com/en-us/azure/ai-services/translator/)) provided by Microsoft.

This module uses API Version 3.0 for text translation and API Version 2024-05-01 for single document translation.

## Copyright notice

(C) 2025, <diko@admins-little-helper.de>  
See [license](LICENSE) for more details.

## Release Notes

See [Release Notes document](./ReleaseNotes.md).

## Module help

See [AzAiTranlator module documentation](./docs/AzAiTranslate.md) for an overview of all functions provided by this module.

## How to install the module

```PowerShell
Install-Module -Name AzAiTranslate
```

## How to update the module

```PowerShell
Update-Module -Name AzAiTranslate
```

## How to uninstall the module

```PowerShell
Uninstall-Module -Name AzAiTranslate
```

## Examples

### Example 1 - Translate a plain text string

This exmaple shows how to translate a source text to multiple target languages.

```PowerShell
Invoke-AzAiTranslateText -InputString "This example shows how to translate a simple string to multiple target languages." -From 'en' -To 'de', 'fr', 'es' -SubsriptionKey "<MySubscriptionKey>" -Verbose -SubscriptionRegion 'germanywestcentral'
```

Output

```PlainText
Text                                                                                                    Language
----                                                                                                    --------
In diesem Beispiel wird gezeigt, wie eine einfache Zeichenkette in mehrere Zielsprachen übersetzt wird. de
Cet exemple montre comment traduire une chaîne simple en plusieurs langues cibles.                      fr
En este ejemplo se muestra cómo traducir una cadena simple a varios idiomas de destino.                 es
```

### Example 2 - Translate a plain text file

In this example the plain text 'InputFile.txt' file gets translated and the result is stored in 'OutputFile.txt'.

```PowerShell
Invoke-AzAiTranslateDocument -Verbose -InputFile .\InputFile.txt -From en -To de -OutputFile .\OutputFile.txt -SubsriptionKey "<MySubscriptionKey>"
```

### Example 3 - Set session variable values

```PowerShell
Set-AzAiSessionSetting -SubsriptionKey "<MySubscriptionKey>" -SubscriptionRegion germanywestcentral -ServiceEndpoint Europe -CustomServiceEndpointUri 'https://my-custom-service-endpoint.cognitiveservices.azure.com'
```

This command sets session variables for the subscription key, the subscription region and the servcie endpoint region to use. These values are then used as default values by all functions in the module that support or require this data. This is a convinient way to skip specifying paramters for subsequent function calls again and again.

After setting the subscription key (API Key), SubscriptionRegion and ServcieEndpoint, you can translate a text by simply using this piece of code:

```PowerShell
Invoke-AzAiTranslateText -InputString "This example shows how to translate a simple string to multiple target languages." -From 'en' -To 'de', 'fr', 'es'
```

### Example 4 - Return the session variable object

```PowerShell
Get-AzAiSessionSetting
```

Output

```PlainText
AzureRegions            : {australiacentral, australiaeast, australiasoutheast, austriaeast…}
ServiceEndpoints        : {[Global, https://api.cognitive.microsofttranslator.com], [Americas, https://api-nam.cognitive.microsofttranslator.com], [AsiaPacific,      
                          https://api-apc.cognitive.microsofttranslator.com], [Europe, https://api-eur.cognitive.microsofttranslator.com]…}
Bcp47LanguageCodes      : {aa, aa-DJ, aa-ER, aa-ET…}
SubscriptionRegionToUse : germanywestcentral
ServiceEndpointToUse    : Custom
TextApiVersion          : 3.0
DocumentApiVersion      : 2024-05-01
Authentication          : @{OcpApimSubscriptionKey=<MySubscriptionKey>; OcpApimSubscriptionRegion=;  
                          Authorization=}
```

### Example 5 - Return a list of supported languages by Azure AI for all scopes

```PowerShell
Get-AzAiSupportedLanguage
```

This will return a PSCustomObject with properties for Dictionary, Translation and Transliteration containing the supported languages for these actions.

#### Example 5a - Return a list of supported languages for translation

```PowerShell
(Get-AzAiSupportedLanguage -Scope Translation).Translation
```

This will return all languages supported by Azure AI to be used for translation.

#### Example 5b - Return a list of supported languages for dictionary lookup

```PowerShell
(Get-AzAiSupportedLanguage -Scope Dictionary).Dictionary
```

This will return all languages supported by Azure AI to be used for dictionary lookup.

## Appendix A - How to setup and configure an Azure AI Translator resource

Follow the steps described in the `Prerequisite` section in the following [guide provided by Microsoft](
https://learn.microsoft.com/en-us/azure/ai-services/translator/text-translation/quickstart/rest-api).
