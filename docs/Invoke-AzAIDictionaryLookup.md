---
external help file: AzAiTranslate-help.xml
Module Name: AzAiTranslate
online version: https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Invoke-AzAiDictionaryLookup.md
schema: 2.0.0
---

# Invoke-AzAiDictionaryLookup

## SYNOPSIS

Lookup up dictionary for a specified word.

## SYNTAX

```
Invoke-AzAiDictionaryLookup [-InputString] <String[]> [-To] <String> [-From] <String>
 [[-ServiceEndpoint] <String>] [[-SubsriptionKey] <String>] [[-SubscriptionRegion] <String>]
 [[-TextApiVersion] <String>] [[-ClientTraceId] <Guid>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION

The 'Invoke-AzAiDictionaryLookup' looks up up dictionary for a specified word.

## EXAMPLES

### EXAMPLE 1

```PowerShell
Invoke-AzAiDictionaryLookup -InputString "Example" -From 'en' -To 'de'
```

This will try lookup the German dictionary record for the English word 'Example'.

## PARAMETERS

### -ClientTraceId

A client-generated GUID to uniquely identify the request.

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -From

The target language (for example 'de').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputString

The string to detect language for.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction

{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceEndpoint

The service endpoint to use.
Can by any of "Global", "Americas", "AsiaPacific", "Europe".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:AzAiSession.ServiceEndpointToUse
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionRegion

The region of the multi-service or regional translator resource.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: $Script:AzAiSession.SubscriptionRegionToUse
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubsriptionKey

The subscript key (API key) of your Azure AI Translator subscription.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Script:AzAiSession.Authentication.OcpApimSubscriptionKey
Accept pipeline input: False
Accept wildcard characters: False
```

### -TextApiVersion

The ApiVersion to use for text translation.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: $Script:AzAiSession.TextApiVersion
Accept pipeline input: False
Accept wildcard characters: False
```

### -To

The source language (for example 'en').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### PSCustomObject

## NOTES

Author:     <diko@admins-little-helper.de>
Email:      <diko@admins-little-helper.de>

## RELATED LINKS

[https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Invoke-AzAiDictionaryLookup.md](https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Invoke-AzAiDictionaryLookup.md)
