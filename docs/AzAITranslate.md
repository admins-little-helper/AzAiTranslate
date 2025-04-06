---
Module Name: AzAiTranslate
Module Guid: 7326afd3-a478-4818-bb15-44827d5ceca4
Download Help Link: {{ Update Download Link }}
Help Version: 1.0.0
Locale: en-US
---

# AzAiTranslate Module

## Description

AzAiTranslate is a PowerShell Module that uses Microsoft's Azure AI Translator REST API for text and document translation. It supports translating text (plain text or html), language detection, dictionary lookup, text transliteration and single document translation.

## AzAiTranslate Cmdlets

### [Get-AzAiSessionSetting](Get-AzAiSessionSetting.md)

Returns the AzAiTranslate session variable.

### [Get-AzAiSupportedDocumentFormat](Get-AzAiSupportedDocumentFormat.md)

Returns a list of file formats supported for document translation.

### [Get-AzAiSupportedGlossaryFormat](Get-AzAiSupportedGlossaryFormat.md)

Returns a list of glossary formats supported for document translation.

### [Get-AzAiSupportedLanguage](Get-AzAiSupportedLanguage.md)

Returns a list of languages supported by the Azure AI Translator REST API for text translation.

### [Invoke-AzAiDetectLanguage](Invoke-AzAiDetectLanguage.md)

Detects language of the specified InputString.

### [Invoke-AzAiDictionaryLookup](Invoke-AzAiDictionaryLookup.md)

Lookup up dictionary for a specified word.

### [Invoke-AzAiTranslateDocument](Invoke-AzAiTranslateDocument.md)

Translate a single document from one language to another using Azure AI Translator REST API.

### [Set-AzAiSessionSetting](Set-AzAiSessionSetting.md)

Set settings for AzAiTranslate module functions, like the subscription key.
