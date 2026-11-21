# Anexos — Caso 4: Predicting Customer Churn at QWE Inc.

*Responsable: Sofía Castiblanco Aguilera*

Todas las tablas de este anexo provienen de los archivos de `04_Resultados/Tablas/`, generados por los scripts de `03_Codigo_R/`.

## A1. Coeficientes del Modelo de Probabilidad Lineal (M1, entrenamiento)

| termino | coeficiente | error_estandar | estadistico | p_valor |
|---|---|---|---|---|
| (Intercept) | 0.06442 | 0.00590 | 10.91135 | 2.05e-27 |
| edad | 0.00085 | 0.00031 | 2.73537 | 0.00625 |
| chi_0 | -0.00025 | 6.05e-05 | -4.13357 | 3.63e-05 |
| chi_var | -0.00030 | 0.00012 | -2.51055 | 0.01209 |
| casos_0 | -0.00062 | 0.00282 | -0.21988 | 0.82598 |
| casos_var | 0.00243 | 0.00229 | 1.06404 | 0.28736 |
| prioridad_0 | -0.00231 | 0.00422 | -0.54738 | 0.58414 |
| prioridad_var | -0.00044 | 0.00326 | -0.13408 | 0.89335 |
| logins_var | -3.95e-05 | 9.17e-05 | -0.43046 | 0.66688 |
| blogs_var | -0.00016 | 0.00079 | -0.20291 | 0.83921 |
| vistas_var | -7.42e-07 | 8.83e-07 | -0.84014 | 0.40087 |
| dias_ult_login_var | 0.00084 | 0.00019 | 4.43226 | 9.52e-06 |

## A2. Coeficientes del logit con edad lineal (M2, entrenamiento)

| termino | coeficiente | error_estandar | estadistico | p_valor |
|---|---|---|---|---|
| (Intercept) | -2.73020 | 0.11885 | -22.97176 | 8.93e-117 |
| edad | 0.01217 | 0.00603 | 2.01986 | 0.04340 |
| chi_0 | -0.00456 | 0.00138 | -3.29896 | 0.00097 |
| chi_var | -0.00809 | 0.00282 | -2.87129 | 0.00409 |
| casos_0 | -0.11314 | 0.10817 | -1.04592 | 0.29560 |
| casos_var | 0.13346 | 0.09119 | 1.46348 | 0.14334 |
| prioridad_0 | -0.01197 | 0.11334 | -0.10560 | 0.91590 |
| prioridad_var | -0.04552 | 0.08587 | -0.53012 | 0.59603 |
| logins_var | -0.00290 | 0.00277 | -1.04691 | 0.29514 |
| blogs_var | -0.00784 | 0.02577 | -0.30418 | 0.76099 |
| vistas_var | -0.00012 | 4.19e-05 | -2.78450 | 0.00536 |
| dias_ult_login_var | 0.01796 | 0.00478 | 3.75412 | 0.00017 |

## A3. Coeficientes del modelo final (logit con segmentos, base completa)

| termino | coeficiente | error_estandar | estadistico | p_valor | odds_ratio | or_ic95_inf | or_ic95_sup |
|---|---|---|---|---|---|---|---|
| (Intercept) | -3.83955 | 0.19962 | -19.23405 | 1.92e-82 | 0.02150 | 0.01454 | 0.03180 |
| segmento_edad6_a_14 | 2.15189 | 0.22814 | 9.43216 | 4.02e-21 | 8.60112 | 5.49994 | 13.45090 |
| segmento_edadMas_14 | 1.87649 | 0.23705 | 7.91595 | 2.45e-15 | 6.53054 | 4.10365 | 10.39268 |
| chi_0 | -0.00964 | 0.00128 | -7.54464 | 4.54e-14 | 0.99041 | 0.98793 | 0.99289 |
| chi_var | -0.00479 | 0.00251 | -1.91026 | 0.05610 | 0.99522 | 0.99034 | 1.00012 |
| casos_0 | -0.08937 | 0.10067 | -0.88775 | 0.37467 | 0.91451 | 0.75075 | 1.11398 |
| casos_var | 0.14090 | 0.08998 | 1.56592 | 0.11737 | 1.15130 | 0.96517 | 1.37334 |
| prioridad_0 | -0.04745 | 0.10038 | -0.47268 | 0.63644 | 0.95366 | 0.78334 | 1.16101 |
| prioridad_var | -0.00034 | 0.07750 | -0.00440 | 0.99649 | 0.99966 | 0.85878 | 1.16364 |
| logins_var | 0.00066 | 0.00212 | 0.31274 | 0.75448 | 1.00066 | 0.99651 | 1.00483 |
| blogs_var | -0.00180 | 0.02177 | -0.08271 | 0.93408 | 0.99820 | 0.95650 | 1.04172 |
| vistas_var | -0.00011 | 4.17e-05 | -2.60010 | 0.00932 | 0.99989 | 0.99981 | 0.99997 |
| dias_ult_login_var | 0.00718 | 0.00330 | 2.17350 | 0.02974 | 1.00720 | 1.00071 | 1.01375 |

## A4. Lift por deciles de riesgo

| decil | clientes | abandonos | tasa | prob_media | lift | captura_acumulada |
|---|---|---|---|---|---|---|
| 1 | 635 | 108 | 0.1701 | 0.1549 | 3.3421 | 0.3344 |
| 2 | 635 | 51 | 0.0803 | 0.0956 | 1.5782 | 0.4923 |
| 3 | 634 | 37 | 0.0584 | 0.0688 | 1.1468 | 0.6068 |
| 4 | 635 | 44 | 0.0693 | 0.0526 | 1.3616 | 0.7430 |
| 5 | 635 | 25 | 0.0394 | 0.0408 | 0.7736 | 0.8204 |
| 6 | 634 | 19 | 0.0300 | 0.0307 | 0.5889 | 0.8793 |
| 7 | 635 | 12 | 0.0189 | 0.0227 | 0.3713 | 0.9164 |
| 8 | 634 | 4 | 0.0063 | 0.0210 | 0.1240 | 0.9288 |
| 9 | 635 | 12 | 0.0189 | 0.0158 | 0.3713 | 0.9659 |
| 10 | 635 | 11 | 0.0173 | 0.0060 | 0.3404 | 1.0000 |

## A5. Lista completa de los 100 clientes con mayor probabilidad de abandono

| ranking | id | edad_meses | segmento_edad | prob_churn | factor_1 | factor_2 | factor_3 | churn_observado |
|---|---|---|---|---|---|---|---|---|
| 1 | 357 | 12 | 6_a_14 | 37.2 % | Cambio vistas (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 2 | 929 | 11 | 6_a_14 | 29.7 % | Cambio vistas (bajo) | Antiguedad 6-14 meses |  | 0 |
| 3 | 2287 | 34 | Mas_14 | 26.2 % | Cambio vistas (bajo) | Antiguedad >14 meses |  | 0 |
| 4 | 3604 | 9 | 6_a_14 | 23.3 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 1 |
| 5 | 335 | 12 | 6_a_14 | 22.4 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 1 |
| 6 | 4680 | 6 | 6_a_14 | 22.0 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio vistas (bajo) | 1 |
| 7 | 299 | 14 | 6_a_14 | 21.9 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 1 |
| 8 | 3671 | 10 | 6_a_14 | 21.9 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 0 |
| 9 | 109 | 40 | Mas_14 | 21.4 % | CHI mes 0 (bajo) | Cambio CHI (bajo) | Antiguedad >14 meses | 0 |
| 10 | 3569 | 9 | 6_a_14 | 21.2 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 1 |
| 11 | 4292 | 7 | 6_a_14 | 21.1 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 12 | 798 | 14 | 6_a_14 | 21.1 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 13 | 1021 | 13 | 6_a_14 | 21.0 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 1 |
| 14 | 2025 | 28 | Mas_14 | 20.8 % | CHI mes 0 (bajo) | Cambio vistas (bajo) | Antiguedad >14 meses | 0 |
| 15 | 3340 | 10 | 6_a_14 | 20.3 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 1 |
| 16 | 240 | 13 | 6_a_14 | 20.3 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 17 | 3504 | 11 | 6_a_14 | 20.2 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 0 |
| 18 | 4276 | 7 | 6_a_14 | 20.2 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 0 |
| 19 | 4245 | 8 | 6_a_14 | 19.9 % | Antiguedad 6-14 meses | CHI mes 0 (bajo) | Cambio CHI (bajo) | 0 |
| 20 | 1971 | 30 | Mas_14 | 19.9 % | CHI mes 0 (bajo) | Cambio CHI (bajo) | Antiguedad >14 meses | 0 |
| 21 | 526 | 13 | 6_a_14 | 19.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 22 | 904 | 14 | 6_a_14 | 19.7 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 1 |
| 23 | 3766 | 10 | 6_a_14 | 19.7 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 24 | 622 | 14 | 6_a_14 | 19.6 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 25 | 3320 | 11 | 6_a_14 | 19.5 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 26 | 3783 | 10 | 6_a_14 | 19.4 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 0 |
| 27 | 991 | 9 | 6_a_14 | 19.4 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 28 | 3356 | 10 | 6_a_14 | 19.1 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 0 |
| 29 | 3219 | 10 | 6_a_14 | 19.0 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 0 |
| 30 | 3724 | 10 | 6_a_14 | 19.0 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 0 |
| 31 | 4954 | 6 | 6_a_14 | 19.0 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 32 | 228 | 14 | 6_a_14 | 19.0 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio CHI (bajo) | 0 |
| 33 | 4532 | 7 | 6_a_14 | 19.0 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 34 | 4111 | 8 | 6_a_14 | 18.9 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 35 | 1809 | 14 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 36 | 2410 | 6 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 37 | 3163 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 38 | 4827 | 6 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 39 | 272 | 14 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 40 | 4240 | 8 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 41 | 413 | 13 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 42 | 4289 | 7 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 43 | 994 | 14 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 44 | 4094 | 8 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 45 | 4263 | 7 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 46 | 4479 | 9 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 47 | 4818 | 6 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 48 | 279 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 49 | 416 | 13 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 50 | 926 | 14 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 51 | 3235 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 52 | 4027 | 8 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 53 | 896 | 14 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 54 | 3265 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 55 | 3734 | 9 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 56 | 551 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 57 | 3526 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 58 | 4594 | 7 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 59 | 3418 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 60 | 4113 | 8 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 61 | 4566 | 7 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 62 | 227 | 13 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 63 | 761 | 10 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 64 | 979 | 13 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 65 | 3536 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 66 | 4076 | 8 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 67 | 257 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 68 | 317 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 69 | 346 | 14 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 70 | 363 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 71 | 371 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 72 | 423 | 10 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 73 | 427 | 13 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 74 | 440 | 13 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 75 | 488 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 76 | 523 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 77 | 543 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 78 | 787 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 79 | 1468 | 9 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 80 | 1760 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 81 | 2985 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 82 | 3139 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 83 | 3152 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 84 | 3186 | 10 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 85 | 3269 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 86 | 3290 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 87 | 3312 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 88 | 3313 | 12 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 89 | 3349 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 90 | 3363 | 9 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 1 |
| 91 | 3417 | 10 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 92 | 3437 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 93 | 3449 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 94 | 3491 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 95 | 3542 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 96 | 3545 | 11 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 97 | 3598 | 10 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 98 | 3600 | 10 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 99 | 3613 | 8 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |
| 100 | 3723 | 8 | 6_a_14 | 18.8 % | CHI mes 0 (bajo) | Antiguedad 6-14 meses | Cambio dias desde ultimo login (alto) | 0 |

Nota: un factor vacío indica que, para ese cliente, solo dos factores significativos elevan su riesgo por encima del cliente promedio.

## A6. Aplicación del modelo a clientes individuales

La probabilidad de cualquier cliente se calcula con la fórmula logística:

$$P(\text{churn}=1) = \frac{1}{1+e^{-(\hat\beta_0 + \hat\beta_1 x_1 + \dots + \hat\beta_k x_k)}}$$

Ejemplos con el modelo final (útiles para la sustentación oral):

| ID | Antigüedad (meses) | Segmento | Probabilidad estimada | Lectura frente a la tasa base (5,1 %) |
|---:|---:|---|---:|---|
| 672 | 16 | Más de 14 | 3,3 % | Por debajo del promedio |
| 354 | 13 | 6 a 14 | 5,1 % | En el promedio |
| 5203 | 4 | Menos de 6 | 1,4 % | Bajo |

En R: `datos$prob_churn[datos$id == 672]` después de ejecutar `04_Resultados.R`.

## A7. Valores de control para verificar la ejecución en R

Después de ejecutar `source("03_Codigo_R/00_Ejecutar_Todo.R")`, la consola y las tablas deben mostrar estos valores. Si alguno no coincide, revisar la versión de los datos o de los scripts antes de entregar.

| Control | Valor esperado | Dónde verlo |
|---|---|---|
| Clientes / abandonos / tasa | 6.347 / 323 / 0,0509 | Consola, script 02 |
| Entrenamiento / prueba | 5.078 (0,0514) / 1.269 (0,0489) | Consola, script 01 |
| Chi-cuadrado por segmentos | 65,54 (gl = 2) | T03 |
| AIC M2 / M3 | 1.985,30 / 1.881,58 | T08 |
| AUC prueba M1 / M2 / M3 | 0,6345 / 0,6396 / 0,6778 | T08 |
| Predicciones del MPL fuera de [0, 1] | 219 | T08 |
| Coeficiente de CHI mes 0 (modelo final) | −0,00964 | T07 |
| AIC del modelo final | 2.353,82 | `AIC(modelo_final)` |
| Matriz de confusión (VP, FN, FP, VN) | 34, 28, 409, 798 | T09 |
| Captura del decil 1 | 0,3344 | T10 |
| Abandonos reales en el top 100 | 29 | Consola, script 04 |
| Cliente n.° 1 del ranking | ID 357, prob. 0,3721 | T11 |
