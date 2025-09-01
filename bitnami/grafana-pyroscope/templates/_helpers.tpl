{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Grafana Pyroscope image name
*/}}
{{- define "grafana-pyroscope.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.pyroscope.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana Pyroscope compactor fullname
*/}}
{{- define "grafana-pyroscope.compactor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "compactor" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Pyroscope distributor fullname
*/}}
{{- define "grafana-pyroscope.distributor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "distributor" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Pyroscope store-gateway fullname
*/}}
{{- define "grafana-pyroscope.store-gateway.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "store-gateway" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Pyroscope ingester fullname
*/}}
{{- define "grafana-pyroscope.ingester.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "ingester" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Pyroscope querier fullname
*/}}
{{- define "grafana-pyroscope.querier.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "querier" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Pyroscope query-frontend fullname
*/}}
{{- define "grafana-pyroscope.query-frontend.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query-frontend" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Return the proper Grafana Pyroscope query-scheduler fullname
*/}}
{{- define "grafana-pyroscope.query-scheduler.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query-scheduler" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Pyroscope tenant-settings fullname
*/}}
{{- define "grafana-pyroscope.tenant-settings.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "tenant-settings" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Pyroscope ad-hoc-profiles fullname
*/}}
{{- define "grafana-pyroscope.ad-hoc-profiles.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "ad-hoc-profiles" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Pyroscope gossip-ring fullname
*/}}
{{- define "grafana-pyroscope.gossip-ring.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "gossip-ring" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Pyroscope alloy fullname
*/}}
{{- define "grafana-pyroscope.minio.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "minio" "chartValues" .Values.minio "context" $) -}}
{{- end -}}

{{/*
Return the proper Grafana Pyroscope profile annotations
*/}}
{{- define "grafana-pyroscope.profileAnnotations" -}}
{{- /* Based on upstream chart: https://github.com/grafana/pyroscope/blob/v1.14.0/operations/pyroscope/helm/pyroscope/rendered/micro-services-hpa.yaml#L2997 */ -}}
profiles.grafana.com/service_repository: "https://github.com/grafana/pyroscope"
profiles.grafana.com/service_git_ref: {{ printf "v%s" .Chart.AppVersion }}
profiles.grafana.com/cpu.port_name: http
profiles.grafana.com/cpu.scrape: "true"
profiles.grafana.com/goroutine.port_name: http
profiles.grafana.com/goroutine.scrape: "true"
profiles.grafana.com/memory.port_name: http
profiles.grafana.com/memory.scrape: "true"
{{- end -}}

{{/*
Return the proper Grafana Pyroscope image name
*/}}
{{- define "grafana-pyroscope.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.defaultInitContainers.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "grafana-pyroscope.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.pyroscope.image .Values.defaultInitContainers.volumePermissions.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "grafana-pyroscope.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the Pyroscope configuration configmap.
*/}}
{{- define "grafana-pyroscope.pyroscope.configmapName" -}}
{{- if .Values.pyroscope.existingConfigmap -}}
    {{- .Values.pyroscope.existingConfigmap -}}
{{- else }}
    {{- printf "%s" (include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the S3 backend host
*/}}
{{- define "grafana-pyroscope.s3.host" -}}
    {{- if .Values.minio.enabled -}}
        {{- include "grafana-pyroscope.minio.fullname" . -}}
    {{- else -}}
        {{- print (tpl .Values.externalS3.host .) -}}

    {{- end -}}
{{- end -}}

{{/*
Return the S3 bucket
*/}}
{{- define "grafana-pyroscope.s3.bucket" -}}
    {{- if .Values.minio.enabled -}}
        {{- print .Values.minio.defaultBuckets -}}
    {{- else -}}
        {{- print .Values.externalS3.bucket -}}
    {{- end -}}
{{- end -}}

{{/*
Return true if TLS is used
*/}}
{{- define "grafana-pyroscope.s3.insecure" -}}
    {{- if .Values.minio.enabled -}}
        {{- not .Values.minio.tls.enabled  -}}
    {{- else -}}
        {{- not .Values.externalS3.tls.enabled  -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 port
*/}}
{{- define "grafana-pyroscope.s3.port" -}}
{{- ternary .Values.minio.service.ports.api .Values.externalS3.port .Values.minio.enabled -}}
{{- end -}}

{{/*
Return the S3 credentials secret name
*/}}
{{- define "grafana-pyroscope.s3.secretName" -}}
{{- if .Values.minio.enabled -}}
    {{- if .Values.minio.auth.existingSecret -}}
        {{- print (tpl .Values.minio.auth.existingSecret .) -}}
    {{- else -}}
        {{- include "grafana-pyroscope.minio.fullname" . -}}
    {{- end -}}
{{- else if .Values.externalS3.existingSecret -}}
    {{- print .Values.externalS3.existingSecret -}}
{{- else -}}
    {{- printf "%s-%s" (include "common.names.fullname" .) "externals3" -}}
{{- end -}}
{{- end -}}

{{/*
Return the S3 access key id inside the secret
*/}}
{{- define "grafana-pyroscope.s3.accessKeyIDKey" -}}
{{- ternary "root-user" .Values.externalS3.existingSecretAccessKeyIDKey .Values.minio.enabled -}}
{{- end -}}

{{/*
Return the S3 secret access key inside the secret
*/}}
{{- define "grafana-pyroscope.s3.secretAccessKeyKey" -}}
{{- ternary "root-password" .Values.externalS3.existingSecretKeySecretKey .Values.minio.enabled -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "grafana-pyroscope.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.pyroscope.image }}
{{- include "common.warnings.rollingTag" .Values.defaultInitContainers.volumePermissions.image }}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "grafana-pyroscope.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "grafana-pyroscope.validateValues.store-gateway" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Loki - Memcached (Chunks) */}}
{{- define "grafana-pyroscope.validateValues.store-gateway" -}}
{{- if and .Values.storeGateway.enabled (not .Values.queryScheduler.enabled) -}}
grafana-pyroscope: store-gateway
    The store-gateway requires the query-scheduler to be enabled.
    Please enable the query-scheduler by setting queryScheduler.enabled=true or disable the
    store-gateway
{{- end -}}
{{- end -}}
