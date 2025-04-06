---
external help file: AzAiTranslate-help.xml
Module Name: AzAiTranslate
online version: https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Set-AzAiSessionSetting.md
schema: 2.0.0
---

# Set-AzAiSessionSetting

## SYNOPSIS

Set settings for AzAiTranslate module functions, like the subscription key.

## SYNTAX

### Default (Default)

```
Set-AzAiSessionSetting [-SubsriptionKey <String>] [-ServiceEndpoint <String>] [-SubscriptionRegion <String>]
 [-TextApiVersion <String>] [-DocumentApiVersion <String>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### CustomEndpoint

```
Set-AzAiSessionSetting [-SubsriptionKey <String>] [-ServiceEndpoint <String>] -CustomServiceEndpointUri <Uri>
 [-SubscriptionRegion <String>] [-TextApiVersion <String>] [-DocumentApiVersion <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The 'Set-AzAiSessionSetting' function allows to et settings for AzAiTranslate module functions, like the subscription key.

## EXAMPLES

### EXAMPLE 1

```PowerShell
Set-AzAiSessionSetting -SubsriptionKey "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
```

Set the SubscriptionKey that will be used by all functions in the AzAiTranslate module, so you don't need to specify it separatly in each function call.

### EXAMPLE 2

```PowerShell
Set-AzAiSessionSetting -ServiceEndpoint Europe CustomServiceEndpointUri 'https://my-custom-service-endpoint.cognitiveservices.azure.com'
```

Set the service endpoint to Custom and the service endpoint URI to your custom endpoint URI '<https://my-custom-service-endpoint.cognitiveservices.azure.com>'.

### EXAMPLE 3

```PowerShell
Set-AzAiSessionSetting -ServiceEndpoint Custom -SubscriptionRegion germanywestcentral
```

Set the service endpoint to Europe and the subsription region to 'GermanyWestCentral'.

## PARAMETERS

### -CustomServiceEndpointUri

The URI for the custom service endpoint.

```yaml
Type: Uri
Parameter Sets: CustomEndpoint
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DocumentApiVersion

Specify the API version to use for document translation.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:AzAiSession.DocumentApiVersion
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
Can by any of "Global", "Americas", "AsiaPacific", "Europe", "Custom".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Global
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
Position: Named
Default value: None
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TextApiVersion

Specify the API version to use for text translation.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:AzAiSession.TextApiVersion
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing

## OUTPUTS

### Nothing

## NOTES

Author:     <diko@admins-little-helper.de>
Email:      <diko@admins-little-helper.de>

## RELATED LINKS

[https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Set-AzAiSessionSetting.md](https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Set-AzAiSessionSetting.md)
