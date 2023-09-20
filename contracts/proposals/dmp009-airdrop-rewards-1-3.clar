;; Title: DMP009 - Airdrop Rewards
;; Author: rozar.btc
;; Synopsis:
;; This proposal airdrops rewards to early users to account for the drip amount increase.

(impl-trait .proposal-trait.proposal-trait)

(define-constant err-generic (err u500))

(define-constant drip-increase-block u118360)

(define-constant holders (list
	'SP3WPN9AJFS3NJA0K5BGBCZGE6ABHMFNS4WWP8K1F
	'SP18QG8A8943KY9S15M08AMAWWF58W9X1M90BRCSJ
	'SP1454QJJZC5E7Q5D25R32Q1WYCGAN2MZHC1W349D
	'SP25SF2MPZZS8Q20QA3VTYJXTHAHCRNM5MSZYDNB0
	'SP161CG3B0H9SC48GRACQB9THE9KD4W93EVSP3C59
	'SP3VGG4NW3NG4DXGF8NF17AF07B6SR674EFC9FXB7
	'SP3R3SNFS6BY45CE8SMAGDA3SMBZVEJXMD5WN5S4K
	'SP2RP3CXBVC492K9B80S6V8PWA28DWEBGKTW6Q78T
	'SP19SM9Z06A40WBEQZTN9MA5N2TB64HXHY8Y3ANT4
	'SP5MX9KTJW1MARJHAQGZM7TM7RD5W8NA6ZBE7E5J
	'SP2WRX7ZAR4Z1SJ5V1NHBXZHWX2112HATSDV4R0Y5
	'SP3JGTGX86B3E36776SXGEHGCHCFQ51P9MX9G7078
	'SP2CA51YWC7J3TCA7G76T6HNRJWD8011412CRYMA6
	'SPF0V8KWBS70F0WDKTMY65B3G591NN52PTHHN51D
	'SP1WXD5423MC1W0M4NSE9WF03X0561ARFX3Y9AQ3F
	'SP2GXZZWBP8C5EDGMWHTHGVAFDBTZW1A3BV03BRXK
	'SP2D5BGGJ956A635JG7CJQ59FTRFRB0893514EZPJ
	'SP1Q634KDQ6VDRN4SGM48XEND42AKD63JP2ANWXBT
	'SPY9K49VE06A66ZXJ3S2ZMJXYJ8HQ08J4MAR4A3R
	'SPPT9EYE1K4MMJGVGRE0FZJNTMBWABJW8Z87C54G
	'SP2FYFFP6JTXC2ZDK0FXNF0BMMBG7G4DBW216KHBY
	'SP29B5CMDYQJ2BFJRVGF60ZNPEY97QP4YM0JV6VQY
	'SP2NPGNBQNC6YX88R1E0QMHYA39JT0KBVGXR0SRPJ
	'SP1RNGKE0CKNQTK371H2VC4DFVYQNZKRCJHVQ2B0T
	'SP1TT3TCC5KS2DN8H462H944FK4RK0CYHEG4BJZ9C
	'SP15VWB3EFJZS1K5GZWT441E3V5NXVQY947515CHW
	'SP3M65P0WSCF58NYX58HBM3ZW830DH28TPBC1T66A
	'SP754HBR0QXFJBC9KK2TGTZ6DETRMRES106J1XKG
	'SP1KW53W5FY4PWY2ZNVHW0GDQS8KBPP8V4KJ6WTGS
	'SP3QGJ5EYZQX48WQ975T458XXCWG9FBDXEEQBXP4P
	'SP20FAC3AT7KXB6KSJ1AVTQC40MGB88BB1WC96VZB
	'SP2K99ESK6KE9Y72PABK30Z336PCP6VA715H64AEK
	'SP2CB6SDWD48FBDDSCJN10947ENCHR0P06NRBEV69
	'SP351RTK5SY0E9NJTBN8PAJCW2831XHGD3BJ82KC7
	'SP1SYZMSPF74DWRHB2DZB5YCHDDRPAESVGG4S6HFZ
	'SP2P3GPA3HG53KKYPW73Q315A1WYYHFV9ZKSCJJY2
	'SP2ZNGJ85ENDY6QRHQ5P2D4FXKGZWCKTB2T0Z55KS
	'SPS0M7JTJS0VHJ5J70YX0SVPRGES6H0CDEX6YX1G
	'SPV4NM7FJZE278GH83BZQNE7Y41XHG8ZTK466GN6
	'SPM2WNFQR1YS9R92191ZAPZGDB800VZG1PQ6KV0J
	'SP27ZFCQ30FYHV6BPP1AFJTSAT2MT6RAW9953RRMT
	'SP3XCABCDY4DEJJKXJA8K07T8SKMTJBT58S3P9V3S
	'SP2METDRVD1GPSEP34J9SZ7G4S53W39RF2DRFC3H9
	'SP2SFFB0M4R2SEKKX1W22CN59KKYNE38R9SSEWJXE
	'SP1D44TYBVVQRDKZSHP1F3ZAB9TR1C3R8TBWZEWS6
	'SP1QJMG03V02V8ARKVA0F5DJA6FBSKQ7G5RHG25VT
	'SP1BDXYK83H5BVM0M0QZN0QR9W937S0TXBMT4XAXF
	'SP3X281G70NRPMGG14BKWHAZV1SXRSMAFV188MVZK
	'SP1VZPAM0M5Z8TA551G5BV7X47XM76J7QZ6RTZWFW
	'SPNHTV2GZTEC2DPV9VPYBKCSY0AWMWSF1HSYQR8A
	'SP38SVWZYT4X77YEM5Z18SV54EPVF42KDWJRW8FXK
	'SP1ZC4FHCZQ45S5BQX7HZ7H88K3HMBE8BEDMJ4RVZ
	'SP1N0AX1JXHWCPA039VQ5T4XS98YP6WP9Q4H3FAM8
	'SP2HDFYNWPRAFTQP21MEQE5BXQD17VH2WCW85JT75
	'SP1XZC778CF19VAMSNZ6W6CCY42Q38QHC5JCEGNGR
	'SP2X1C48RV66H37ZZF8PRAWSX6MKJMA3AQVHYEXW5
	'SP3S3BM45SYCRK0P9TG32RPAKVTW4D10FJ0YVJQBM
	'SP3WMA9QG9BKJK8T6X8A0VVVESFEDB4VB2ZAB2B79
	'SP141Y4P9XX0NMQED0KJPZHBPN2F8CY9QGB72WS06
	'SPZ0QA2CW48FFFNA0NXCD3Y4RCR5XJAQ741CZJH3
	'SP8T0S3TESB0832TNT6V7YP13YYZFDY2EP423N3K
	'SP1CZE3943AZMXG7NRJG31V0D0TXJQYWSYHTBWVP1
	'SPVN9KXKZV7KEHCPV54791QP0QTHAK9NFJMGR0ZJ
	'SPF1RR5KXZW6PHGM0G1AAJ2YJFS9WG1NC3FSJWFJ
	'SP3G7N0S318KFG949JVDCMA3XN9BQR7BKGHX3C7JR
	'SP2AVCTMFCWJRNHSWWDG475C6V6J21N02G04YC5FE
	'SP1WQFWQHAQMVS0J0KFNS5YRVJ5MT73QDN34JFF57
	'SPW7CTE9T18WG4HG4N2HYZJ49ST2Y6CGKTFWAWHS
	'SP2S9YDNQ19PGBJEZVN9NDG77MNZS95BJQEBF46WT
	'SP1ATKARHDKHH21VNWVV5GH2DY4RP2XVA0ZD7DR1M
	'SP1JGNGWSZ2Q180SY6SD388AC59Z5CY18010RHZFV
	'SP1PHAGEQ5RWM8G84DFGMRPENKQGFC4QJ9YWXAYKF
	'SP3ZDQ5JRQYJ67WQR3HQRFFGMQ2120NJRJ7RDT044
	'SPP9HES6XPG9JGEDTQWRY5A2T5MMYVNR9788ZN85
	'SP1H05NRF0C79J54GDWYR35598HA4EHGG83A2SQV4
	'SP3HB77VX3JZQEF579A7CEW90SJJ6Y5R13BQ0J7EF
	'SP3Q2HBW3WMKY528NG0SSVQYTSKPPC24H3RREJESH
	'SP2T6JNZ7XGAPG505T590GYJ1A05Z1KXC800DHFTX
	'SPHA1FGJC5CKK6T5CJFDF2ASKTDM3R9QAZB0Y1Q2
	'SP2APSYKV1K4EQ39V6T3KPBS62RA9WV5DM333GP75
	'SP1F85MQ2ZZATTYA927R6E2SFEM5SX2G06RR5S2B5
	'SP1Z1SA47MK2430DVMGQV92V92CA19RJGQ06VPJ8Q
	'SP2GMKYSQQ7RP4TSGQ1QJAMMV7ZY3JFTPJCRE3S4F
	'SP18QHTV135FQ6J1GX8P9NCNVDN10V7TQTFM2H67H
	'SP3G94QD0Q60Z4TZJP00CXS66KC4R6MMXVJ5A7C6F
	'SP32681KRBDH0PM2QB12ZR0KXHEHPNWFXM45AVXVH
	'SPEKRD38B17X6DTQQRZR8CJKGABSE8SBYRRJAWNT
	'SP1YKGGQ6MC8XRA9WY05M6M1V6MGZ7CN4GV1KC2VZ
	'SP225EHYV4NCTW172KCZKDN9M5VTAFC2EVT55DCMH
	'SP38QBKWK4BK5NHJSR6V6TGS4GZJTMFEZ23132V3F
	'SPX4ZVCQJG3HDWCPPT4KEWNHY2TARWCWPJ90YN7K
	'SP2KV6FS6ZQFMA84GV1QFN8B8PMGR1RS3A22FSWX8
	'SP3N7NY81SWYJB5W843PD9MJPG7F595RYBCFFZMGR
	'SP1BJP3FJ9R20R9C5ZD0Y28XH1ZKPZZPCS9K9S3DR
	)
)

(define-private (airdrop-rewards (address principal))
	(let
		(
			(amount (unwrap! (contract-call? .balance-at-block get-balance-at-block address drip-increase-block) err-generic))
		)
		(try! (contract-call? .dme000-governance-token dmg-mint (* amount u2) address))
		(ok true)
	)
)

(define-public (execute (sender principal))
	(begin
		(map airdrop-rewards holders)
        (ok true)
	)
)