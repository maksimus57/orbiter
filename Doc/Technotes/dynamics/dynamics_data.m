clear all
close all

% Initial parameters for semi-major axis (SMa), periapsis altitude (PeA)
% and apoapsis altitude (ApA) (all in km)

tgt_SMa = 6588.12;
tgt_PeA = 210.70;
tgt_ApA = 223.52;

% drift and standard deviation over 10-day simulation as function
% of fixed step length
% data: dt[s], avg(SMa)[M], std(SMa)[M], avg(PeA)[k], std(PeA)[k],
% avg(ApA)[k], std(ApA)[k]

linacc_single = [3  6588.08 0.022   210.63  0.065   223.52  0.022
    4  6588.03 0.051   210.58  0.095   223.46  0.007
    5   6587.95 0.100   210.49  0.144   223.83  0.056
    6   6587.82 0.172   210.37  0.216   223.25  0.128
    7   6587.65 0.274   210.19  0.318   223.08  0.230
    8   6587.41 0.409   209.96  0.453   222.84  0.365
    10  6586.74 0.799   209.28  0.842   222.17  0.756
    15  6583.44 2.704   205.99  2.742   218.87  2.667
    20  6576.99 6.444   199.56  6.469   212.40  6.419];

linacc_double = [4  6588.12 0.00063 210.67  0.044   223.55  0.044
    5  6588.12 0.00065 210.67  0.044   223.55  0.045
    6   6588.12 0.00083 210.67  0.045   223.55  0.045
    10  6588.12 0.00135 210.66  0.047   223.56  0.047
    15  6588.12 0.00244 210.66  0.050   223.56  0.051
    20  6588.12 0.00421 210.65  0.054   223.56  0.056
    25  6588.12 0.00682 210.65  0.059   223.57  0.064
    30   6588.12 0.011   210.64  0.061   223.58  0.075
    40   6588.16 0.033   210.66  0.053   223.63  0.110
    50   6588.25 0.091   210.74  0.025   223.74  0.176
    60   6588.47 0.221   210.96  0.143   223.96  0.301
    70   6588.90 0.477   211.40  0.419   224.38  0.536
    80   6589.67 0.930   212.20  0.904   225.12  0.958
    90   6590.96 1.681   213.52  1.680   226.38  1.683
    100  6592.98 2.854   215.56  2.855   228.39  2.854
    110  6596.02 4.610   218.59  4.594   231.43  4.626
    120  6600.41 7.133   222.98  7.104   235.82  7.162];

quadacc = [9    6588.12 0.00055 210.63  0.044   223.59  0.044
    10 6588.12 0.00068 210.63  0.044   223.59  0.044
    15  6588.12 0.00056 210.63  0.044   223.59  0.044
    20  6588.12 0.00062 210.63  0.044   223.59  0.044
    25  6588.12 0.00069 210.63  0.044   223.59  0.044
    30  6588.12 0.00090 210.63  0.045   223.59  0.043
    40  6588.11 0.00328 210.62  0.047   223.59  0.041
    50  6588.10 0.00964 210.61  0.054   223.58  0.034
    60  6588.08 0.024   210.58  0.068   223.55  0.020
    70  6588.03 0.05    210.53  0.10    223.51  0.01
    80  6587.95 0.10    210.45  0.14    223.43  0.06
    90  6587.81 0.18    210.30  0.22    223.29  0.14
    100 6587.59 0.31    210.08  0.35    223.08  0.27
    110 6587.27 0.49    209.76  0.53    222.77  0.46
    120 6586.81 0.756   209.29  0.790   222.31  0.725
    130 6586.17 1.126   208.64  1.154   221.68  1.101
    140 6585.31 1.626   207.76  1.648   220.83  1.610
    150 6584.16 2.291   206.60  2.302   219.70  2.285];

% Runge-Kutta methods

rk2 = [2    6588.13 0.00327 210.62  0.042   223.61  0.049
    3    6588.14 0.01080 210.65  0.040    223.61 0.059
    4    6588.16 0.02556 210.69  0.043   223.62  0.080
    5    6588.21 0.04989 210.75  0.061   223.64  0.112
    6   6588.27 0.08620 210.84  0.097   223.68  0.157
    7   6588.36 0.13685 210.95  0.151   223.74  0.217
    8   6588.47 0.20424 211.10  0.223   223.83  0.294
    10  6588.81 0.399   211.51  0.429   224.09  0.507
    20  6593.63 3.173   216.80  3.259   228.43  3.375
    30  6606.52 10.575    229.90  10.693  241.13  10.870];

rk3 = [5    6588.00 0.06652 210.51  0.110   223.48  0.023
    6    6587.92 0.11497 210.43  0.159   223.39  0.071
    7    6587.80 0.18259 210.31  0.226   223.28  0.139
    8    6587.65 0.27260 210.16  0.316   223.12  0.230
    9    6587.45 0.38822 209.96  0.431   222.92  0.346
    10   6587.20 0.53267 209.71  0.574   222.67  0.491
    15  6585.00 1.80139 207.52  1.837   220.47  1.766];

rk4 = [10   6588.12 0.00053 210.63  0.044   223.59  0.044
    15   6588.12 0.00049 210.63  0.044   223.59  0.044
    20   6588.12 0.00060 210.63  0.045   223.59  0.044
    25  6588.12 0.00131 210.63  0.045   223.59  0.043
    30  6588.12 0.00306 210.62  0.047   223.59  0.041
    40  6588.10 0.013   210.61  0.057   223.57  0.032
    50  6588.06 0.039   210.55  0.083   223.54  0.006
    60  6587.96 0.096   210.46  0.141   223.43  0.052
    70  6587.76 0.208   210.27  0.252   223.24  0.164
    80  6587.42 0.406   209.93  0.450   222.90  0.362
    90  6586.86 0.733   209.36  0.776   222.34  0.690
    100 6585.98 1.243   208.48  1.285   221.46  1.202
    110 6584.66 2.007   207.16  2.046   220.14  1.968
    120 6582.76 3.109   205.25  3.145   218.24  3.074];

rk5 = [20   6588.12 0.00057 210.61  0.044   223.61  0.044
    25   6588.12 0.00057 210.61  0.044   223.61  0.044
    30   6588.12 0.00057 210.61  0.044   223.61  0.044
    40   6588.12 0.00060 210.61  0.044   223.61  0.045
    50   6588.12 0.00087 210.61  0.044   223.61  0.045
    60   6588.12 0.00172 210.62  0.043   223.61  0.046
    70   6588.13 0.00329 210.62  0.041   223.61  0.048
    80   6588.13 0.00578 210.62  0.039   223.62  0.050
    90   6588.14 0.00926 210.63  0.035   223.62  0.054
    100  6588.14 0.01356 210.64  0.031   223.63  0.058
    110 6588.15 0.01807 210.64  0.026   223.64  0.062
    120 6588.16 0.02159 210.65  0.023   223.64  0.066
    130 6588.16 0.02199 210.65  0.022   223.65  0.066
    140 6588.15 0.01591 210.64  0.028   223.63  0.060
    150 6588.12 0.00172 210.61  0.045   223.60  0.042
    160 6588.05 0.03763 210.55  0.080   223.54  0.006
    170 6587.94 0.10177 210.44  0.143   223.43  0.060
    180 6587.76 0.20684 210.26  0.246   233.24  0.168
    190 6587.48 0.36967 209.98  0.406   222.96  0.333
    200 6587.06 0.61154 209.57  0.644   222.54  0.579
    210 6586.46 0.95987 208.97  0.986   221.93  0.933
    220 6585.62 1.44820 208.14  1.467   221.07  1.430
    230 6584.46 2.11838 206.99  2.126   219.90  2.111
    240 6582.90 3.02179 205.45  3.016   218.33  3.028];

rk6 = [40   6588.12 0.00057 210.61  0.044   223.61  0.044
    50  6588.12 0.00057 210.61  0.044   223.61  0.044
    60  6588.12 0.00053 210.61  0.044   223.61  0.044
    70  6588.12 0.00061 210.61  0.044   223.61  0.044
    80  6588.12 0.00058 210.61  0.044   223.61  0.004
    90  6588.12 0.00065 210.61  0.044   223.61  0.045
    100 6588.12 0.00076 210.61  0.044   223.61  0.045
    110 6588.12 0.00113 210.61  0.043   223.61  0.045
    120 6588.12 0.00196 210.62  0.043   223.61  0.046
    130 6588.13 0.00336 210.62  0.041   223.61  0.048
    140 6588.13 0.00566 210.62  0.039   223.62  0.050
    150 6588.14 0.00931 210.63  0.036   223.62  0.054
    160 6588.15 0.015   210.64  0.031   223.63  0.060
    170	6588.16	0.023	210.65	0.023	223.65	0.069
    180 6588.18 0.035   210.67  0.012   223.67  0.081
    190 6588.21 0.052   210.70  0.004   223.70  0.099
    200 6588.25 0.075   210.74  0.026   223.74  0.124
    210 6588.31 0.107   210.79  0.056   223.80  0.158
    220 6588.38 0.151   210.86  0.097   223.88  0.205
    230 6588.48 0.210   210.96  0.153   223.99  0.267
    240 6588.62 0.288   211.09  0.226   224.13  0.350
    250 6588.80 0.390   211.25  0.322   224.32  0.458
    260 6589.03 0.523   211.47  0.447   224.56  0.599
    270 6589.32 0.694   211.76  0.608   224.87  0.780
    280 6589.70 0.913   212.12  0.815   225.27  1.011
    290 6590.18 1.190   212.57  1.076   225.77  1.304
    300 6590.79 1.537   213.15  1.404   226.41  1.671];

rk7 = [100  6588.12 0.00056 210.61  0.044   223.61  0.044
    110 6588.12 0.00055 210.61  0.044   223.61  0.044
    120 6588.12 0.00055 210.61  0.044   223.61  0.044
    130 6588.12 0.00057 210.61  0.044   223.61  0.044
    140 6588.12 0.00057 210.61  0.045   223.61  0.044
    150 6588.12 0.00060 210.61  0.045   223.61  0.044
    160 6588.12 0.00070 210.61  0.045   223.61  0.044
    170 6588.12 0.00087 210.61  0.045   223.61  0.044
    180 6588.12 0.00110 210.61  0.045   223.61  0.043
    190 6588.12 0.00152 210.61  0.046   223.61  0.043
    200 6588.12 0.00205 210.61  0.046   223.61  0.042
    210 6588.12 0.00278 210.61  0.047   223.60  0.042
    220 6588.11 0.00378 210.60  0.048   223.60  0.041
    230 6588.11 0.00505 210.60  0.049   223.60  0.039
    240 6588.11 0.00668 210.60  0.051   223.60  0.038
    250 6588.10 0.00875 210.60  0.053   223.59  0.036
    260 6588.10 0.01131 210.59  0.056   223.59  0.033
    270 6588.09 0.01447 210.59  0.059   223.58  0.030
    280 6588.09 0.01831 210.58  0.062   223.58  0.026
    290 6588.08 0.02296 210.57  0.067   223.57  0.021
    300 6588.07 0.02852 210.56  0.072   223.56  0.015
    350 6587.99 0.07449 210.48  0.118   223.48  0.031
    400 6587.84 0.16250 210.33  0.204   223.32  0.121
    450 6587.60 0.30210 210.09  0.340   223.08  0.264
    500 6587.29 0.47580 209.80  0.507   222.77  0.445
    550 6587.08 0.60213 209.59  0.621   222.54  0.583
    600 6587.29 0.47742 209.83  0.476   222.73  0.480
    650 6588.65 0.30355 211.22  0.343   224.05  0.269
    700 6592.37 2.43640 215.01  2.533   227.71  2.342];

rk8 = [160  6588.12 0.00057 210.61  0.044   223.61  0.044
    170 6588.12  0.00055 210.61  0.044   223.61  0.044
    180 6588.12  0.00056 210.61  0.044   223.61  0.044
    190 6588.12  0.00059 210.61  0.044   223.61  0.044
    200 6588.12  0.00055 210.61  0.044   223.61  0.045
    210 6588.12 0.00059 210.61  0.044   223.61  0.045
    220 6588.12 0.00063 210.61  0.044   223.61  0.045
    230 6588.12 0.00074 210.61  0.044   223.61  0.045
    240 6588.12 0.00090 210.61  0.044   223.61  0.045
    250 6588.12 0.00115 210.61  0.043   223.61  0.045
    260 6588.12 0.00153 210.61  0.043   223.61  0.046
    270 6588.12 0.00206 210.61  0.042   223.62  0.046
    280 6588.12 0.00283 210.61  0.042   223.62  0.047
    290 6588.13 0.00384 210.61  0.041   223.62  0.048
    300 6588.13 0.00519 210.62  0.039   223.62  0.050
    350 6588.16 0.02078 210.64  0.024   223.65  0.066
    400 6588.24 0.06947 210.73  0.024   223.73  0.115
    450 6588.47 0.20112 210.95  0.154   223.96  0.249
    500 6589.02 0.51891 211.50  0.467   224.52  0.571
    550 6590.23 1.21701 212.70  1.156   225.74  1.278
    600 6592.69 2.62904 215.14  2.552   228.22  2.706
    650 6597.33 5.28235 219.75  5.177   232.90  5.388
    700 6605.50 9.91287 227.86  9.763   241.13  10.063];

% Symplectic methods

sp2 = [4    6588.12 0.00055 210.62  0.046   223.60  0.046
    5   6588.12 0.00060 210.63  0.049   223.59  0.049
    6   6588.12 0.00050 210.63  0.053   223.59  0.053
    8   6588.12 0.00053 210.66  0.068   223.57  0.069
    10  6588.12 0.00047 210.68  0.092   223.54  0.093
    15  6588.12 0.00066 210.77  0.188   223.45  0.188
    20  6588.12 0.00081 210.89  0.327   223.33  0.328
    25  6588.12 0.00105 211.03  0.508   223.19  0.509
    30  6588.12 0.00145 211.18  0.729   223.04  0.730
    40  6588.12 0.00249 211.47  1.284   222.76  1.284
    50  6588.13 0.00403 211.58  1.961   222.65  1.962
    60  6588.13 0.00618 211.26  2.685   222.98  2.685
    70  6588.14 0.00903 210.25  3.272   224.00  3.275
    80  6588.15 0.01262 208.59  3.845   225.68  3.852
    90  6588.16 0.01715 206.50  4.679   227.80  4.694
    100 6588.17 0.02344 204.03  5.771   230.30  5.797
    120 6588.22 0.04914 198.13  8.559   236.30  8.636
    140 6588.30 0.09966 191.03  11.982  243.55  12.160
    160 6588.41 0.16444 182.82  15.954  251.98  16.259
    180 6588.57 0.25257 173.59  20.427  261.52  20.903
    200 6588.78 0.39715 163.42  25.312  272.13  26.071
    220 6589.06 0.56755 152.34  30.626  283.75  31.717
    240 6589.42 0.80099 140.43  36.307  296.38  37.854
    260 6589.86 1.09150 127.67  42.353  310.03  44.466
    280 6590.41 1.44644 114.06  48.660  324.74  51.466
    300 6591.07 1.88103  99.87  55.315  340.25  58.969];

sp4 = [20   6588.12 0.00060 210.61  0.044   223.61  0.045
    25  6588.12 0.00059 210.61  0.045   223.61  0.045
    30  6588.12	0.00057	210.61	0.045	223.61	0.045
    40  6588.12 0.00062 210.61  0.046   223.61  0.046
    50  6588.12 0.00055 210.62  0.051   223.60  0.052
    60  6588.12 0.00060 210.64  0.065   223.58  0.066
    70  6588.12 0.00060 210.66  0.095   223.56  0.096
    80  6588.12 0.00070 210.69  0.145   223.53  0.146
    90  6588.12 0.00081 210.74  0.222   223.48  0.223
    100 6588.12 0.00092 210.81  0.329   223.41  0.331
    110 6588.12 0.00111 210.89  0.474   223.33  0.476
    120 6588.12 0.00133 210.98  0.662   223.24  0.664
    130 6588.12 0.00165 211.07  0.899   223.15  0.903
    140 6588.12 0.00202 211.14  1.193   223.08  1.196
    150 6588.12 0.00247 211.18  1.545   223.04  1.550
    160 6588.12 0.00303 211.12  1.957   223.10  1.963
    170 6588.12 0.00376 210.91  2.423   223.31  2.430
    180 6588.12 0.00475 210.47  2.931   223.75  2.940
    190 6588.13 0.00618 209.74  3.464   224.49  3.475
    200 6588.13 0.00827 208.68  4.022   225.56  4.038
    210 6588.13 0.01132 207.31  4.659   226.94  4.681
    220 6588.14 0.01568 205.65  5.400   228.61  5.430
    230 6588.15 0.02179 203.73  6.259   230.55  6.301
    240 6588.16 0.03018 201.55  7.239   232.75  7.298
    250 6588.18 0.04137 199.11  8.348   235.23  8.428
    260 6588.20 0.05591 196.37  9.610   238.01  9.719
    270 6588.23 0.07426 193.31  11.057  241.12  11.201
    280 6588.26 0.09702 189.91  12.711  244.59  12.900
    290 6588.30 0.12502 186.15  14.517  248.43  14.761
    300 6588.35 0.15946 182.12  16.459  252.57  16.770
    350 6588.80 0.46872 157.51  28.090  278.07  29.005
    400 6589.76 1.12320 125.12  43.133  312.38  45.325
    450 6591.52 2.31012 85.51   61.072  355.50  65.580];

sp6 = [100  6588.12 0.00057 210.61  0.044   223.61  0.044
    110 6588.12 0.00053 210.61  0.045   223.61  0.045
    120 6588.12 0.00055 210.61  0.045   223.61  0.045
    130 6588.12 0.00055 210.61  0.045   223.61  0.045
    140 6588.12 0.00058 210.61  0.045   223.61  0.045
    150 6588.12 0.00055 210.61  0.045   223.61  0.045
    160 6588.12 0.00060 210.61  0.046   223.61  0.046
    170 6588.12 0.00059 210.61  0.047   223.61  0.047
    180 6588.12 0.00058 210.62  0.048   223.60  0.048
    190 6588.12 0.00059 210.62  0.050   223.60  0.050
    200 6588.12 0.00060 210.62  0.053   223.60  0.054
    210 6588.12 0.00058 210.63  0.058   223.59  0.059
    220 6588.12 0.00062 210.63  0.065   223.58  0.066
    240 6588.12 0.00060 210.65  0.087   223.57  0.088
    260 6588.12 0.00066 210.68  0.124   223.54  0.125
    280 6588.12 0.00074 210.72  0.179   223.50  0.180
    300 6588.12 0.00085 210.77  0.257   223.45  0.259
    350 6588.12 0.00127 210.95  0.590   223.27  0.592
    400 6588.12 0.00205 211.19  1.200   223.03  1.203
    450 6588.12 0.00326 211.16  2.166   223.06  2.172
    500 6588.12 0.00581 209.98  3.398   224.25  3.409
    550 6588.14 0.01293 206.78  4.759   227.47  4.784
    600 6588.16 0.03053 201.71  6.959   232.59  7.018
    650 6588.21 0.06474 194.68  10.298  239.72  10.424
    700 6588.31 0.12719 185.79  14.558  248.80  14.806
    750 6588.46 0.23230 175.05  19.675  259.85  20.128
    800 6588.70 0.39378 162.46  25.647  272.92  26.415
    850 6589.05 0.62957 148.16  32.399  287.92  33.628
    900 6589.53 0.95888 132.33  39.807  304.71  41.678
    950 6590.18 1.39357 115.03  47.866  323.30  50.585
    1000 6591.01 1.95394 96.46  56.380  343.54  60.193];

sp8 = [200  6588.12 0.00057 210.61  0.045   223.61  0.045
    250  6588.12 0.00057 210.60  0.049   223.62  0.049
    300  6588.12 0.00058 210.61  0.065   223.61  0.065
    350  6588.12 0.00062 210.66  0.133   223.56  0.134
    400  6588.12 0.00090 210.91  0.359   223.31  0.360
    450  6588.12 0.00153 211.63  0.923   222.60  0.925
    500  6588.12 0.00254 212.81  1.947   221.41  1.948
    550  6588.13 0.00723 211.03  2.193   223.21  2.202
    600  6588.15 0.02122 206.22  4.105   228.05  4.144
    650  6588.20 0.04053 199.72  6.047   234.66  6.120
    700  6588.31 0.10100 189.33  11.318  245.27  11.510
    750  6588.52 0.22059 175.67  18.015  259.35  18.440
    800  6588.90 0.45517 158.06  26.639  277.71  27.523
    850  6589.51 0.85075 137.04  36.858  299.96  38.516
    900  6590.44 1.46922 112.88  48.669  325.99  51.534
    950  6591.77 2.36754  86.46  61.905  355.05  66.524
    1000 6593.48 3.57218  59.33  76.311  385.61  83.281];

figure
semilogx(rk2(:,1),rk2(:,2)-tgt_SMa,'ks-','LineWidth',1.5);
hold on
semilogx(rk4(:,1),rk4(:,2)-tgt_SMa,'ko-','LineWidth',1.5);
semilogx(rk5(:,1),rk5(:,2)-tgt_SMa,'k*-','LineWidth',1.5);
semilogx(rk6(:,1),rk6(:,2)-tgt_SMa,'kd-','LineWidth',1.5);
semilogx(rk7(:,1),rk7(:,2)-tgt_SMa,'k+-','LineWidth',1.5);
semilogx(rk8(:,1),rk8(:,2)-tgt_SMa,'k^-','LineWidth',1.5);
semilogx(linacc_single(:,1),linacc_single(:,2)-tgt_SMa,'ks--','LineWidth',1.5);
semilogx(linacc_double(:,1),linacc_double(:,2)-tgt_SMa,'ko--','LineWidth',1.5);
semilogx(quadacc(:,1),quadacc(:,2)-tgt_SMa,'kd--','LineWidth',1.5)
xlabel ('step interval [s]');
ylabel ('mean SMa drift [km]');
%legend('RK2 (2-stage)','RK4 (4-stage)','RK5 (6-stage)','RK6
%(8-stage)','RK7 (11-stage)','linear model, single pass','linear model, double pass','quadratic model');
text(10,1.8,'RK2','BackgroundColor','white','EdgeColor','black');
text(80,-1.85,'RK4','BackgroundColor','white','EdgeColor','black');
text(190,-1.85,'RK5','BackgroundColor','white','EdgeColor','black');
text(250,1.8,'RK6','BackgroundColor','white','EdgeColor','black');
text(380,-0.5,'RK7','BackgroundColor','white','EdgeColor','black');
text(450,1.8,'RK8','BackgroundColor','white','EdgeColor','black');
text(9.2,-1.85,'L/s','BackgroundColor','white','EdgeColor','black');
text(75,1.8,'L/d','BackgroundColor','white','EdgeColor','black');
text(120,-1.85,'Q','BackgroundColor','white','EdgeColor','black');
axis([2 700 -2 2]);

figure
loglog(rk2(:,1),rk2(:,3),'ks-','LineWidth',1.5);
hold on
%loglog(rk3(:,1),rk3(:,3),'k^-','LineWidth',1.5);
loglog(rk4(:,1),rk4(:,3),'ko-','LineWidth',1.5);
loglog(rk5(:,1),rk5(:,3),'k*-','LineWidth',1.5);
loglog(rk6(:,1),rk6(:,3),'kd-','LineWidth',1.5);
loglog(rk7(:,1),rk7(:,3),'k+-','LineWidth',1.5);
loglog(rk8(:,1),rk8(:,3),'k^-','LineWidth',1.5);
loglog(linacc_single(:,1),linacc_single(:,3),'ks--','LineWidth',1.5);
loglog(linacc_double(:,1),linacc_double(:,3),'ko--','LineWidth',1.5);
loglog(quadacc(:,1),quadacc(:,3),'kd--','LineWidth',1.5)
xlabel ('step interval [s]');
ylabel ('SMa standard deviation [km]');
%legend('RK2 (2-stage)','RK4 (4-stage)','RK5 (6-stage)','RK6 (8-stage)','RK7 (11-stage)','linear model, single pass','linear model, double pass','quadratic model');
text(14,1.1,'RK2','BackgroundColor','white','EdgeColor','black');
text(19,0.0009,'RK4','BackgroundColor','white','EdgeColor','black');
text(43,0.0009,'RK5','BackgroundColor','white','EdgeColor','black');
text(90,0.0009,'RK6','BackgroundColor','white','EdgeColor','black');
text(150,0.0009,'RK7','BackgroundColor','white','EdgeColor','black');
text(220,0.0009,'RK8','BackgroundColor','white','EdgeColor','black');
text(9,1.1,'L/s','BackgroundColor','white','EdgeColor','black');
text(6.7,0.0009,'L/d','BackgroundColor','white','EdgeColor','black');
text(30,0.0009,'Q','BackgroundColor','white','EdgeColor','black');
axis([2 700 5e-4 2]);

figure
loglog(rk2(:,1),rk2(:,3),'k--','LineWidth',0.5);
hold on
loglog(rk4(:,1),rk4(:,3),'k--','LineWidth',0.5);
loglog(rk6(:,1),rk6(:,3),'k--','LineWidth',0.5);
loglog(rk8(:,1),rk8(:,3),'k--','LineWidth',0.5);
loglog(sp2(:,1),sp2(:,3),'ks-','LineWidth',1.5);
loglog(sp4(:,1),sp4(:,3),'ko-','LineWidth',1.5);
loglog(sp6(:,1),sp6(:,3),'kd-','LineWidth',1.5);
loglog(sp8(:,1),sp8(:,3),'k^-','LineWidth',1.5);
xlabel ('step interval [s]');
ylabel ('SMa standard deviation [km]');
text(10,0.0009,'SY2','BackgroundColor','white','EdgeColor','black');
text(55,0.0009,'SY4','BackgroundColor','white','EdgeColor','black');
text(270,0.0009,'SY6','BackgroundColor','white','EdgeColor','black');
text(390,0.0009,'SY8','BackgroundColor','white','EdgeColor','black');
text(5,3e-2,'RK2');
text(23,5e-3,'RK4');
text(100,5e-3,'RK6');
text(320,5e-3,'RK8');
axis([4 1000 4e-4 2]);

figure
loglog(rk2(:,1),rk2(:,5),'k--','LineWidth',0.5);
hold on
loglog(rk4(:,1),rk4(:,5),'k--','LineWidth',0.5);
loglog(rk6(:,1),rk6(:,5),'k--','LineWidth',0.5);
loglog(rk8(:,1),rk8(:,5),'k--','LineWidth',0.5);
loglog(sp2(:,1),sp2(:,5),'ks-','LineWidth',1.5);
loglog(sp4(:,1),sp4(:,5),'ko-','LineWidth',1.5);
loglog(sp6(:,1),sp6(:,5),'kd-','LineWidth',1.5);
loglog(sp8(:,1),sp8(:,5),'k^-','LineWidth',1.5);
xlabel ('step interval [s]');
ylabel ('perigee altitude standard deviation [km]');
text(9,0.09,'SY2','BackgroundColor','white','EdgeColor','black');
text(60,0.09,'SY4','BackgroundColor','white','EdgeColor','black');
text(220,0.09,'SY6','BackgroundColor','white','EdgeColor','black');
text(310,0.09,'SY8','BackgroundColor','white','EdgeColor','black');
text(10,1,'RK2');
text(70,1,'RK4');
text(210,1,'RK6');
text(590,1,'RK8');
axis([4 1000 5e-3 1e1]);
