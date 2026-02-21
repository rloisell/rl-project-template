{{/*
_helpers.tpl
Ryan Loiselle — Developer / Architect | GitHub Copilot | February 2026
Common template helpers for the <APP_NAME> Helm chart.
Replace <APP_NAME> with the actual application name slug.
*/}}

{{/* Full name of the chart */}}
{{- define "<APP_NAME>.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Chart name */}}
{{- define "<APP_NAME>.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Chart + version label */}}
{{- define "<APP_NAME>.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Common labels applied to all resources */}}
{{- define "<APP_NAME>.labels" -}}
helm.sh/chart: {{ include "<APP_NAME>.chart" . }}
app.kubernetes.io/name: {{ include "<APP_NAME>.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/* Selector labels */}}
{{- define "<APP_NAME>.selectorLabels" -}}
app.kubernetes.io/name: {{ include "<APP_NAME>.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Service account name */}}
{{- define "<APP_NAME>.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "<APP_NAME>.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
