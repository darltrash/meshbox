local characters = {
    ['0'] = {x=175, y=190, w=7, h=9,  ox=1,  oy=8}, ['1'] = {x=182, y=190, w=7, h=9,  ox=1,  oy=8},
    ['2'] = {x=189, y=190, w=7, h=9,  ox=1,  oy=8}, ['3'] = {x=196, y=190, w=7, h=9,  ox=1,  oy=8},
    ['4'] = {x=203, y=190, w=7, h=9,  ox=1,  oy=8}, ['5'] = {x=210, y=190, w=7, h=9,  ox=1,  oy=8},
    ['6'] = {x=217, y=190, w=7, h=9,  ox=1,  oy=8}, ['7'] = {x=224, y=190, w=7, h=9,  ox=1,  oy=8},
    ['8'] = {x=0,   y=200, w=7, h=9,  ox=1,  oy=8}, ['9'] = {x=7,   y=200, w=7, h=9,  ox=1,  oy=8},
    ['!'] = {x=212, y=227, w=3, h=9,  ox=-1, oy=8}, ['"'] = {x=7,   y=251, w=5, h=5,  ox=0,  oy=8},
    ['#'] = {x=224, y=227, w=7, h=8,  ox=1,  oy=7}, ['$'] = {x=14,  y=200, w=7, h=9,  ox=1,  oy=8},
    ['%'] = {x=21,  y=200, w=7, h=9,  ox=1,  oy=8}, ['&'] = {x=28,  y=200, w=7, h=9,  ox=1,  oy=8},
    ['\'']= {x=26,  y=251, w=3, h=5,  ox=-1, oy=8}, ['('] = {x=192, y=227, w=4, h=9,  ox=-1, oy=8},
    [')'] = {x=196, y=227, w=4, h=9,  ox=0,  oy=8}, ['*'] = {x=52,  y=236, w=7, h=7,  ox=1,  oy=7},
    ['+'] = {x=59,  y=236, w=7, h=7,  ox=1,  oy=7}, [','] = {x=22,  y=251, w=4, h=5,  ox=0,  oy=3},
    ['-'] = {x=65,  y=251, w=7, h=3,  ox=1,  oy=5}, ['.'] = {x=62,  y=251, w=3, h=4,  ox=-1, oy=3},
    ['/'] = {x=35,  y=200, w=7, h=9,  ox=1,  oy=8}, [':'] = {x=49,  y=236, w=3, h=8,  ox=-1, oy=7},
    [';'] = {x=200, y=227, w=4, h=9,  ox=0,  oy=7}, ['<'] = {x=66,  y=236, w=7, h=7,  ox=1,  oy=7},
    ['='] = {x=214, y=244, w=7, h=5,  ox=1,  oy=6}, ['>'] = {x=73,  y=236, w=7, h=7,  ox=1,  oy=7},
    ['?'] = {x=42,  y=200, w=7, h=9,  ox=1,  oy=8}, ['@'] = {x=49,  y=200, w=7, h=9,  ox=1,  oy=8},
    ['A'] = {x=56,  y=200, w=7, h=9,  ox=1,  oy=8}, ['B'] = {x=63,  y=200, w=7, h=9,  ox=1,  oy=8},
    ['C'] = {x=70,  y=200, w=7, h=9,  ox=1,  oy=8}, ['D'] = {x=77,  y=200, w=7, h=9,  ox=1,  oy=8},
    ['E'] = {x=84,  y=200, w=7, h=9,  ox=1,  oy=8}, ['F'] = {x=91,  y=200, w=7, h=9,  ox=1,  oy=8},
    ['G'] = {x=98,  y=200, w=7, h=9,  ox=1,  oy=8}, ['H'] = {x=105, y=200, w=7, h=9,  ox=1,  oy=8},
    ['I'] = {x=112, y=200, w=7, h=9,  ox=1,  oy=8}, ['J'] = {x=119, y=200, w=7, h=9,  ox=1,  oy=8},
    ['K'] = {x=126, y=200, w=7, h=9,  ox=1,  oy=8}, ['L'] = {x=133, y=200, w=7, h=9,  ox=1,  oy=8},
    ['M'] = {x=140, y=200, w=7, h=9,  ox=1,  oy=8}, ['N'] = {x=147, y=200, w=7, h=9,  ox=1,  oy=8},
    ['O'] = {x=154, y=200, w=7, h=9,  ox=1,  oy=8}, ['P'] = {x=161, y=200, w=7, h=9,  ox=1,  oy=8},
    ['Q'] = {x=46,  y=179, w=7, h=10, ox=1,  oy=8}, ['R'] = {x=168, y=200, w=7, h=9,  ox=1,  oy=8},
    ['S'] = {x=175, y=200, w=7, h=9,  ox=1,  oy=8}, ['T'] = {x=182, y=200, w=7, h=9,  ox=1,  oy=8},
    ['U'] = {x=189, y=200, w=7, h=9,  ox=1,  oy=8}, ['V'] = {x=196, y=200, w=7, h=9,  ox=1,  oy=8},
    ['W'] = {x=203, y=200, w=7, h=9,  ox=1,  oy=8}, ['X'] = {x=210, y=200, w=7, h=9,  ox=1,  oy=8},
    ['Y'] = {x=217, y=200, w=7, h=9,  ox=1,  oy=8}, ['Z'] = {x=224, y=200, w=7, h=9,  ox=1,  oy=8},
    ['['] = {x=204, y=227, w=4, h=9,  ox=-1, oy=8}, ['\\'] ={x=0,   y=209, w=7, h=9,  ox=1,  oy=8},
    [']'] = {x=208, y=227, w=4, h=9,  ox=0,  oy=8}, ['^'] = {x=221, y=244, w=7, h=5,  ox=1,  oy=8},
    ['_'] = {x=72,  y=251, w=7, h=3,  ox=1,  oy=2}, ['`'] = {x=50,  y=251, w=4, h=4,  ox=0,  oy=8},
    ['a'] = {x=80,  y=236, w=7, h=7,  ox=1,  oy=6}, ['b'] = {x=7,   y=209, w=7, h=9,  ox=1,  oy=8},
    ['c'] = {x=87,  y=236, w=7, h=7,  ox=1,  oy=6}, ['d'] = {x=14,  y=209, w=7, h=9,  ox=1,  oy=8},
    ['e'] = {x=94,  y=236, w=7, h=7,  ox=1,  oy=6}, ['f'] = {x=21,  y=209, w=7, h=9,  ox=1,  oy=8},
    ['g'] = {x=28,  y=209, w=7, h=9,  ox=1,  oy=6}, ['h'] = {x=35,  y=209, w=7, h=9,  ox=1,  oy=8},
    ['i'] = {x=42,  y=209, w=7, h=9,  ox=1,  oy=8}, ['j'] = {x=182, y=156, w=7, h=11, ox=1,  oy=8},
    ['k'] = {x=49,  y=209, w=7, h=9,  ox=1,  oy=8}, ['l'] = {x=56,  y=209, w=7, h=9,  ox=1,  oy=8},
    ['m'] = {x=101, y=236, w=7, h=7,  ox=1,  oy=6}, ['n'] = {x=108, y=236, w=7, h=7,  ox=1,  oy=6},
    ['o'] = {x=115, y=236, w=7, h=7,  ox=1,  oy=6}, ['p'] = {x=63,  y=209, w=7, h=9,  ox=1,  oy=6},
    ['q'] = {x=70,  y=209, w=7, h=9,  ox=1,  oy=6}, ['r'] = {x=122, y=236, w=7, h=7,  ox=1,  oy=6},
    ['s'] = {x=129, y=236, w=7, h=7,  ox=1,  oy=6}, ['t'] = {x=77,  y=209, w=7, h=9,  ox=1,  oy=8},
    ['u'] = {x=136, y=236, w=7, h=7,  ox=1,  oy=6}, ['v'] = {x=143, y=236, w=7, h=7,  ox=1,  oy=6},
    ['w'] = {x=150, y=236, w=7, h=7,  ox=1,  oy=6}, ['x'] = {x=157, y=236, w=7, h=7,  ox=1,  oy=6},
    ['y'] = {x=84,  y=209, w=7, h=9,  ox=1,  oy=6}, ['z'] = {x=164, y=236, w=7, h=7,  ox=1,  oy=6},
    ['{'] = {x=182, y=227, w=5, h=9,  ox=0,  oy=8}, ['|'] = {x=215, y=227, w=3, h=9,  ox=-1, oy=8},
    ['}'] = {x=187, y=227, w=5, h=9,  ox=0,  oy=8}, ['~'] = {x=29,  y=251, w=7, h=4,  ox=1,  oy=6},
    ['¡'] = {x=218, y=227, w=3, h=9,  ox=-1, oy=8}, ['¢'] = {x=91,  y=209, w=7, h=9,  ox=1,  oy=8},
    ['£'] = {x=98,  y=209, w=7, h=9,  ox=1,  oy=8}, ['¤'] = {x=171, y=236, w=7, h=7,  ox=1,  oy=7},
    ['¥'] = {x=105, y=209, w=7, h=9,  ox=1,  oy=8}, ['¦'] = {x=221, y=227, w=3, h=9,  ox=-1, oy=8},
    ['§'] = {x=112, y=209, w=7, h=9,  ox=1,  oy=8}, ['¨'] = {x=93,  y=251, w=5, h=3,  ox=0,  oy=8},
    ['©'] = {x=119, y=209, w=7, h=9,  ox=1,  oy=8}, ['ª'] = {x=175, y=244, w=6, h=7,  ox=1,  oy=8},
    ['«'] = {x=228, y=244, w=7, h=5,  ox=1,  oy=6}, ['¬'] = {x=36,  y=251, w=7, h=4,  ox=1,  oy=5},
    ['®'] = {x=126, y=209, w=7, h=9,  ox=1,  oy=8}, ['¯'] = {x=79,  y=251, w=7, h=3,  ox=1,  oy=5},
    ['°'] = {x=208, y=244, w=6, h=6,  ox=1,  oy=8}, ['±'] = {x=133, y=209, w=7, h=9,  ox=1,  oy=8},
    ['²'] = {x=193, y=244, w=5, h=7,  ox=1,  oy=8}, ['³'] = {x=198, y=244, w=5, h=7,  ox=1,  oy=8},
    ['´'] = {x=54,  y=251, w=4, h=4,  ox=-1, oy=9}, ['µ'] = {x=140, y=209, w=7, h=9,  ox=1,  oy=6},
    ['¶'] = {x=147, y=209, w=7, h=9,  ox=1,  oy=8}, ['·'] = {x=98,  y=251, w=3, h=3,  ox=-1, oy=8},
    ['¸'] = {x=12,  y=251, w=5, h=5,  ox=0,  oy=2}, ['¹'] = {x=203, y=244, w=5, h=7,  ox=1,  oy=8},
    ['º'] = {x=181, y=244, w=6, h=7,  ox=1,  oy=8}, ['»'] = {x=0,   y=251, w=7, h=5,  ox=1,  oy=6},
    ['¼'] = {x=154, y=209, w=7, h=9,  ox=1,  oy=8}, ['½'] = {x=161, y=209, w=7, h=9,  ox=1,  oy=8},
    ['¾'] = {x=168, y=209, w=7, h=9,  ox=1,  oy=8}, ['¿'] = {x=175, y=209, w=7, h=9,  ox=1,  oy=8},
    ['À'] = {x=15,  y=143, w=7, h=12, ox=1,  oy=11},['Á'] = {x=22,  y=143, w=7, h=12, ox=1,  oy=11},
    ['Â'] = {x=29,  y=143, w=7, h=12, ox=1,  oy=11},['Ã'] = {x=36,  y=143, w=7, h=12, ox=1,  oy=11},
    ['Ä'] = {x=189, y=156, w=7, h=11, ox=1,  oy=10},['Å'] = {x=43,  y=143, w=7, h=12, ox=1,  oy=11},
    ['Æ'] = {x=182, y=209, w=7, h=9,  ox=1,  oy=8}, ['Ç'] = {x=196, y=156, w=7, h=11, ox=1,  oy=8},
    ['È'] = {x=50,  y=143, w=7, h=12, ox=1,  oy=11},['É'] = {x=57,  y=143, w=7, h=12, ox=1,  oy=11},
    ['Ê'] = {x=64,  y=143, w=7, h=12, ox=1,  oy=11},['Ë'] = {x=203, y=156, w=7, h=11, ox=1,  oy=10},
    ['Ì'] = {x=71,  y=143, w=7, h=12, ox=1,  oy=11},['Í'] = {x=78,  y=143, w=7, h=12, ox=1,  oy=11},
    ['Î'] = {x=85,  y=143, w=7, h=12, ox=1,  oy=11},['Ï'] = {x=210, y=156, w=7, h=11, ox=1,  oy=10},
    ['Ð'] = {x=135, y=190, w=8, h=9,  ox=2,  oy=8}, ['Ñ'] = {x=92,  y=143, w=7, h=12, ox=1,  oy=11},
    ['Ò'] = {x=99,  y=143, w=7, h=12, ox=1,  oy=11},['Ó'] = {x=106, y=143, w=7, h=12, ox=1,  oy=11},
    ['Ô'] = {x=113, y=143, w=7, h=12, ox=1,  oy=11},['Õ'] = {x=120, y=143, w=7, h=12, ox=1,  oy=11},
    ['Ö'] = {x=217, y=156, w=7, h=11, ox=1,  oy=10},['×'] = {x=17,  y=251, w=5, h=5,  ox=0,  oy=5},
    ['Ø'] = {x=189, y=209, w=7, h=9,  ox=1,  oy=8}, ['Ù'] = {x=127, y=143, w=7, h=12, ox=1,  oy=11},
    ['Ú'] = {x=134, y=143, w=7, h=12, ox=1,  oy=11},['Û'] = {x=141, y=143, w=7, h=12, ox=1,  oy=11},
    ['Ü'] = {x=224, y=156, w=7, h=11, ox=1,  oy=10},['Ý'] = {x=148, y=143, w=7, h=12, ox=1,  oy=11},
    ['Þ'] = {x=196, y=209, w=7, h=9,  ox=1,  oy=8}, ['ß'] = {x=203, y=209, w=7, h=9,  ox=1,  oy=8},
    ['à'] = {x=53,  y=179, w=7, h=10, ox=1,  oy=9}, ['á'] = {x=60,  y=179, w=7, h=10, ox=1,  oy=9},
    ['â'] = {x=67,  y=179, w=7, h=10, ox=1,  oy=9}, ['ã'] = {x=74,  y=179, w=7, h=10, ox=1,  oy=9},
    ['ä'] = {x=210, y=209, w=7, h=9,  ox=1,  oy=8}, ['å'] = {x=0,   y=168, w=7, h=11, ox=1,  oy=10},
    ['æ'] = {x=178, y=236, w=7, h=7,  ox=1,  oy=6}, ['ç'] = {x=217, y=209, w=7, h=9,  ox=1,  oy=6},
    ['è'] = {x=81,  y=179, w=7, h=10, ox=1,  oy=9}, ['é'] = {x=88,  y=179, w=7, h=10, ox=1,  oy=9},
    ['ê'] = {x=95,  y=179, w=7, h=10, ox=1,  oy=9}, ['ë'] = {x=224, y=209, w=7, h=9,  ox=1,  oy=8},
    ['ì'] = {x=102, y=179, w=7, h=10, ox=1,  oy=9}, ['í'] = {x=109, y=179, w=7, h=10, ox=1,  oy=9},
    ['î'] = {x=116, y=179, w=7, h=10, ox=1,  oy=9}, ['ï'] = {x=0,   y=218, w=7, h=9,  ox=1,  oy=8},
    ['ð'] = {x=30,  y=179, w=8, h=10, ox=1,  oy=9}, ['ñ'] = {x=123, y=179, w=7, h=10, ox=1,  oy=9},
    ['ò'] = {x=130, y=179, w=7, h=10, ox=1,  oy=9}, ['ó'] = {x=137, y=179, w=7, h=10, ox=1,  oy=9},
    ['ô'] = {x=144, y=179, w=7, h=10, ox=1,  oy=9}, ['õ'] = {x=151, y=179, w=7, h=10, ox=1,  oy=9},
    ['ö'] = {x=7,   y=218, w=7, h=9,  ox=1,  oy=8}, ['÷'] = {x=185, y=236, w=7, h=7,  ox=1,  oy=6},
    ['ø'] = {x=192, y=236, w=7, h=7,  ox=1,  oy=6}, ['ù'] = {x=158, y=179, w=7, h=10, ox=1,  oy=9},
    ['ú'] = {x=165, y=179, w=7, h=10, ox=1,  oy=9}, ['û'] = {x=172, y=179, w=7, h=10, ox=1,  oy=9},
    ['ü'] = {x=14,  y=218, w=7, h=9,  ox=1,  oy=8}, ['ý'] = {x=155, y=143, w=7, h=12, ox=1,  oy=9},
    ['þ'] = {x=7,   y=168, w=7, h=11, ox=1,  oy=8}, ['ÿ'] = {x=14,  y=168, w=7, h=11, ox=1,  oy=8},
    ['Ā'] = {x=21,  y=168, w=7, h=11, ox=1,  oy=10},['ā'] = {x=21,  y=218, w=7, h=9,  ox=1,  oy=8},
    ['Ă'] = {x=162, y=143, w=7, h=12, ox=1,  oy=11},['ă'] = {x=179, y=179, w=7, h=10, ox=1,  oy=9},
    ['Ą'] = {x=28,  y=168, w=7, h=11, ox=1,  oy=8}, ['ą'] = {x=28,  y=218, w=7, h=9,  ox=1,  oy=6},
    ['Ć'] = {x=169, y=143, w=7, h=12, ox=1,  oy=11},['ć'] = {x=186, y=179, w=7, h=10, ox=1,  oy=9},
    ['Ĉ'] = {x=176, y=143, w=7, h=12, ox=1,  oy=11},['ĉ'] = {x=193, y=179, w=7, h=10, ox=1,  oy=9},
    ['Ċ'] = {x=35,  y=168, w=7, h=11, ox=1,  oy=10},['ċ'] = {x=35,  y=218, w=7, h=9,  ox=1,  oy=8},
    ['Č'] = {x=183, y=143, w=7, h=12, ox=1,  oy=11},['č'] = {x=200, y=179, w=7, h=10, ox=1,  oy=9},
    ['Ď'] = {x=190, y=143, w=7, h=12, ox=1,  oy=11},['ď'] = {x=21,  y=179, w=9, h=10, ox=1,  oy=9},
    ['Đ'] = {x=143, y=190, w=8, h=9,  ox=2,  oy=8}, ['đ'] = {x=38,  y=179, w=8, h=10, ox=1,  oy=9},
    ['Ē'] = {x=42,  y=168, w=7, h=11, ox=1,  oy=10},['ē'] = {x=42,  y=218, w=7, h=9,  ox=1,  oy=8},
    ['Ĕ'] = {x=197, y=143, w=7, h=12, ox=1,  oy=11},['ĕ'] = {x=207, y=179, w=7, h=10, ox=1,  oy=9},
    ['Ė'] = {x=49,  y=168, w=7, h=11, ox=1,  oy=10},['ė'] = {x=49,  y=218, w=7, h=9,  ox=1,  oy=8},
    ['Ę'] = {x=56,  y=168, w=7, h=11, ox=1,  oy=8}, ['ę'] = {x=56,  y=218, w=7, h=9,  ox=1,  oy=6},
    ['Ě'] = {x=63,  y=168, w=7, h=11, ox=1,  oy=10},['ě'] = {x=63,  y=218, w=7, h=9,  ox=1,  oy=8},
    ['Ĝ'] = {x=204, y=143, w=7, h=12, ox=1,  oy=11},['ĝ'] = {x=211, y=143, w=7, h=12, ox=1,  oy=9},
    ['Ğ'] = {x=218, y=143, w=7, h=12, ox=1,  oy=11},['ğ'] = {x=225, y=143, w=7, h=12, ox=1,  oy=9},
    ['Ġ'] = {x=70,  y=168, w=7, h=11, ox=1,  oy=10},['ġ'] = {x=77,  y=168, w=7, h=11, ox=1,  oy=8},
    ['Ģ'] = {x=84,  y=168, w=7, h=11, ox=1,  oy=8}, ['ģ'] = {x=0,   y=156, w=7, h=12, ox=1,  oy=9},
    ['Ĥ'] = {x=7,   y=156, w=7, h=12, ox=1,  oy=11},['ĥ'] = {x=214, y=179, w=7, h=10, ox=1,  oy=9},
    ['Ħ'] = {x=126, y=190, w=9, h=9,  ox=2,  oy=8}, ['ħ'] = {x=151, y=190, w=8, h=9,  ox=2,  oy=8},
    ['Ĩ'] = {x=14,  y=156, w=7, h=12, ox=1,  oy=11},['ĩ'] = {x=221, y=179, w=7, h=10, ox=1,  oy=9},
    ['Ī'] = {x=91,  y=168, w=7, h=11, ox=1,  oy=10},['ī'] = {x=70,  y=218, w=7, h=9,  ox=1,  oy=8},
    ['Ĭ'] = {x=21,  y=156, w=7, h=12, ox=1,  oy=11},['ĭ'] = {x=228, y=179, w=7, h=10, ox=1,  oy=9},
    ['Į'] = {x=98,  y=168, w=7, h=11, ox=1,  oy=8}, ['į'] = {x=105, y=168, w=7, h=11, ox=1,  oy=8},
    ['İ'] = {x=28,  y=156, w=7, h=12, ox=1,  oy=11},['ı'] = {x=199, y=236, w=7, h=7,  ox=1,  oy=6},
    ['Ĳ'] = {x=77,  y=218, w=7, h=9,  ox=1,  oy=8}, ['ĳ'] = {x=112, y=168, w=7, h=11, ox=1,  oy=8},
    ['Ĵ'] = {x=35,  y=156, w=7, h=12, ox=1,  oy=11},['ĵ'] = {x=7,   y=143, w=8, h=12, ox=1,  oy=9},
    ['Ķ'] = {x=119, y=168, w=7, h=11, ox=1,  oy=8}, ['ķ'] = {x=126, y=168, w=7, h=11, ox=1,  oy=8},
    ['ĸ'] = {x=206, y=236, w=7, h=7,  ox=1,  oy=6}, ['Ĺ'] = {x=42,  y=156, w=7, h=12, ox=1,  oy=11},
    ['ĺ'] = {x=49,  y=156, w=7, h=12, ox=1,  oy=11},['Ļ'] = {x=133, y=168, w=7, h=11, ox=1,  oy=8},
    ['ļ'] = {x=140, y=168, w=7, h=11, ox=1,  oy=8}, ['Ľ'] = {x=84,  y=218, w=7, h=9,  ox=1,  oy=8},
    ['ľ'] = {x=91,  y=218, w=7, h=9,  ox=1,  oy=8}, ['Ŀ'] = {x=98,  y=218, w=7, h=9,  ox=1,  oy=8},
    ['ŀ'] = {x=105, y=218, w=7, h=9,  ox=1,  oy=8}, ['Ł'] = {x=159, y=190, w=8, h=9,  ox=2,  oy=8},
    ['ł'] = {x=112, y=218, w=7, h=9,  ox=1,  oy=8}, ['Ń'] = {x=56,  y=156, w=7, h=12, ox=1,  oy=11},
    ['ń'] = {x=0,   y=190, w=7, h=10, ox=1,  oy=9}, ['Ņ'] = {x=147, y=168, w=7, h=11, ox=1,  oy=8},
    ['ņ'] = {x=119, y=218, w=7, h=9,  ox=1,  oy=6}, ['Ň'] = {x=63,  y=156, w=7, h=12, ox=1,  oy=11},
    ['ň'] = {x=7,   y=190, w=7, h=10, ox=1,  oy=9}, ['ŉ'] = {x=167, y=190, w=8, h=9,  ox=2,  oy=8},
    ['Ŋ'] = {x=154, y=168, w=7, h=11, ox=1,  oy=8}, ['ŋ'] = {x=126, y=218, w=7, h=9,  ox=1,  oy=6},
    ['Ō'] = {x=161, y=168, w=7, h=11, ox=1,  oy=10},['ō'] = {x=133, y=218, w=7, h=9,  ox=1,  oy=8},
    ['Ŏ'] = {x=70,  y=156, w=7, h=12, ox=1,  oy=11},['ŏ'] = {x=14,  y=190, w=7, h=10, ox=1,  oy=9},
    ['Ő'] = {x=77,  y=156, w=7, h=12, ox=1,  oy=11},['ő'] = {x=21,  y=190, w=7, h=10, ox=1,  oy=9},
    ['Œ'] = {x=140, y=218, w=7, h=9,  ox=1,  oy=8}, ['œ'] = {x=213, y=236, w=7, h=7,  ox=1,  oy=6},
    ['Ŕ'] = {x=84,  y=156, w=7, h=12, ox=1,  oy=11},['ŕ'] = {x=28,  y=190, w=7, h=10, ox=1,  oy=9},
    ['Ŗ'] = {x=168, y=168, w=7, h=11, ox=1,  oy=8}, ['ŗ'] = {x=147, y=218, w=7, h=9,  ox=1,  oy=6},
    ['Ř'] = {x=91,  y=156, w=7, h=12, ox=1,  oy=11},['ř'] = {x=35,  y=190, w=7, h=10, ox=1,  oy=9},
    ['Ś'] = {x=98,  y=156, w=7, h=12, ox=1,  oy=11},['ś'] = {x=42,  y=190, w=7, h=10, ox=1,  oy=9},
    ['Ŝ'] = {x=105, y=156, w=7, h=12, ox=1,  oy=11},['ŝ'] = {x=49,  y=190, w=7, h=10, ox=1,  oy=9},
    ['Ş'] = {x=175, y=168, w=7, h=11, ox=1,  oy=8}, ['ş'] = {x=154, y=218, w=7, h=9,  ox=1,  oy=6},
    ['Š'] = {x=112, y=156, w=7, h=12, ox=1,  oy=11},['š'] = {x=56,  y=190, w=7, h=10, ox=1,  oy=9},
    ['Ţ'] = {x=182, y=168, w=7, h=11, ox=1,  oy=8}, ['ţ'] = {x=189, y=168, w=7, h=11, ox=1,  oy=8},
    ['Ť'] = {x=119, y=156, w=7, h=12, ox=1,  oy=11},['ť'] = {x=63,  y=190, w=7, h=10, ox=1,  oy=9},
    ['Ŧ'] = {x=161, y=218, w=7, h=9,  ox=1,  oy=8}, ['ŧ'] = {x=168, y=218, w=7, h=9,  ox=1,  oy=8},
    ['Ũ'] = {x=126, y=156, w=7, h=12, ox=1,  oy=11},['ũ'] = {x=70,  y=190, w=7, h=10, ox=1,  oy=9},
    ['Ū'] = {x=196, y=168, w=7, h=11, ox=1,  oy=10},['ū'] = {x=175, y=218, w=7, h=9,  ox=1,  oy=8},
    ['Ŭ'] = {x=133, y=156, w=7, h=12, ox=1,  oy=11},['ŭ'] = {x=77,  y=190, w=7, h=10, ox=1,  oy=9},
    ['Ů'] = {x=0,   y=143, w=7, h=13, ox=1,  oy=12},['ů'] = {x=203, y=168, w=7, h=11, ox=1,  oy=10},
    ['Ű'] = {x=140, y=156, w=7, h=12, ox=1,  oy=11},['ű'] = {x=84,  y=190, w=7, h=10, ox=1,  oy=9},
    ['Ų'] = {x=210, y=168, w=7, h=11, ox=1,  oy=8}, ['ų'] = {x=182, y=218, w=7, h=9,  ox=1,  oy=6},
    ['Ŵ'] = {x=147, y=156, w=7, h=12, ox=1,  oy=11},['ŵ'] = {x=91,  y=190, w=7, h=10, ox=1,  oy=9},
    ['Ŷ'] = {x=154, y=156, w=7, h=12, ox=1,  oy=11},['ŷ'] = {x=161, y=156, w=7, h=12, ox=1,  oy=9},
    ['Ÿ'] = {x=217, y=168, w=7, h=11, ox=1,  oy=10},['Ź'] = {x=168, y=156, w=7, h=12, ox=1,  oy=11},
    ['ź'] = {x=98,  y=190, w=7, h=10, ox=1,  oy=9}, ['Ż'] = {x=224, y=168, w=7, h=11, ox=1,  oy=10},
    ['ż'] = {x=189, y=218, w=7, h=9,  ox=1,  oy=8}, ['Ž'] = {x=175, y=156, w=7, h=12, ox=1,  oy=11},
    ['ž'] = {x=105, y=190, w=7, h=10, ox=1,  oy=9}, ['Ё'] = {x=0,   y=179, w=7, h=11, ox=1,  oy=10},
    ['А'] = {x=196, y=218, w=7, h=9,  ox=1,  oy=8}, ['Б'] = {x=203, y=218, w=7, h=9,  ox=1,  oy=8},
    ['В'] = {x=210, y=218, w=7, h=9,  ox=1,  oy=8}, ['Г'] = {x=217, y=218, w=7, h=9,  ox=1,  oy=8},
    ['Д'] = {x=112, y=190, w=7, h=10, ox=1,  oy=8}, ['Е'] = {x=224, y=218, w=7, h=9,  ox=1,  oy=8},
    ['Ж'] = {x=0,   y=227, w=7, h=9,  ox=1,  oy=8}, ['З'] = {x=7,   y=227, w=7, h=9,  ox=1,  oy=8},
    ['И'] = {x=14,  y=227, w=7, h=9,  ox=1,  oy=8}, ['Й'] = {x=7,   y=179, w=7, h=11, ox=1,  oy=10},
    ['К'] = {x=21,  y=227, w=7, h=9,  ox=1,  oy=8}, ['Л'] = {x=28,  y=227, w=7, h=9,  ox=1,  oy=8},
    ['М'] = {x=35,  y=227, w=7, h=9,  ox=1,  oy=8}, ['Н'] = {x=42,  y=227, w=7, h=9,  ox=1,  oy=8},
    ['О'] = {x=49,  y=227, w=7, h=9,  ox=1,  oy=8}, ['П'] = {x=56,  y=227, w=7, h=9,  ox=1,  oy=8},
    ['Р'] = {x=63,  y=227, w=7, h=9,  ox=1,  oy=8}, ['С'] = {x=70,  y=227, w=7, h=9,  ox=1,  oy=8},
    ['Т'] = {x=77,  y=227, w=7, h=9,  ox=1,  oy=8}, ['У'] = {x=84,  y=227, w=7, h=9,  ox=1,  oy=8},
    ['Ф'] = {x=91,  y=227, w=7, h=9,  ox=1,  oy=8}, ['Х'] = {x=98,  y=227, w=7, h=9,  ox=1,  oy=8},
    ['Ц'] = {x=105, y=227, w=7, h=9,  ox=1,  oy=7}, ['Ч'] = {x=112, y=227, w=7, h=9,  ox=1,  oy=8},
    ['Ш'] = {x=119, y=227, w=7, h=9,  ox=1,  oy=8}, ['Щ'] = {x=119, y=190, w=7, h=10, ox=1,  oy=8},
    ['Ъ'] = {x=0,   y=236, w=7, h=8,  ox=1,  oy=7}, ['Ы'] = {x=7,   y=236, w=7, h=8,  ox=1,  oy=7},
    ['Ь'] = {x=14,  y=236, w=7, h=8,  ox=1,  oy=7}, ['Э'] = {x=126, y=227, w=7, h=9,  ox=1,  oy=8},
    ['Ю'] = {x=133, y=227, w=7, h=9,  ox=1,  oy=8}, ['Я'] = {x=21,  y=236, w=7, h=8,  ox=1,  oy=7},
    ['а'] = {x=220, y=236, w=7, h=7,  ox=1,  oy=6}, ['б'] = {x=140, y=227, w=7, h=9,  ox=1,  oy=8},
    ['в'] = {x=227, y=236, w=7, h=7,  ox=1,  oy=6}, ['г'] = {x=0,   y=244, w=7, h=7,  ox=1,  oy=6},
    ['д'] = {x=28,  y=236, w=7, h=8,  ox=1,  oy=6}, ['е'] = {x=7,   y=244, w=7, h=7,  ox=1,  oy=6},
    ['ж'] = {x=14,  y=244, w=7, h=7,  ox=1,  oy=6}, ['з'] = {x=187, y=244, w=6, h=7,  ox=1,  oy=6},
    ['и'] = {x=21,  y=244, w=7, h=7,  ox=1,  oy=6}, ['й'] = {x=147, y=227, w=7, h=9,  ox=1,  oy=8},
    ['к'] = {x=28,  y=244, w=7, h=7,  ox=1,  oy=6}, ['л'] = {x=35,  y=244, w=7, h=7,  ox=1,  oy=6},
    ['м'] = {x=42,  y=244, w=7, h=7,  ox=1,  oy=6}, ['н'] = {x=49,  y=244, w=7, h=7,  ox=1,  oy=6},
    ['о'] = {x=56,  y=244, w=7, h=7,  ox=1,  oy=6}, ['п'] = {x=63,  y=244, w=7, h=7,  ox=1,  oy=6},
    ['р'] = {x=154, y=227, w=7, h=9,  ox=1,  oy=6}, ['с'] = {x=70,  y=244, w=7, h=7,  ox=1,  oy=6},
    ['т'] = {x=77,  y=244, w=7, h=7,  ox=1,  oy=6}, ['у'] = {x=161, y=227, w=7, h=9,  ox=1,  oy=6},
    ['ф'] = {x=14,  y=179, w=7, h=11, ox=1,  oy=8}, ['х'] = {x=84,  y=244, w=7, h=7,  ox=1,  oy=6},
    ['ц'] = {x=35,  y=236, w=7, h=8,  ox=1,  oy=6}, ['ч'] = {x=91,  y=244, w=7, h=7,  ox=1,  oy=6},
    ['ш'] = {x=98,  y=244, w=7, h=7,  ox=1,  oy=6}, ['щ'] = {x=42,  y=236, w=7, h=8,  ox=1,  oy=6},
    ['ъ'] = {x=105, y=244, w=7, h=7,  ox=1,  oy=6}, ['ы'] = {x=112, y=244, w=7, h=7,  ox=1,  oy=6},
    ['ь'] = {x=119, y=244, w=7, h=7,  ox=1,  oy=6}, ['э'] = {x=126, y=244, w=7, h=7,  ox=1,  oy=6},
    ['ю'] = {x=133, y=244, w=7, h=7,  ox=1,  oy=6}, ['я'] = {x=140, y=244, w=7, h=7,  ox=1,  oy=6},
    ['ё'] = {x=168, y=227, w=7, h=9,  ox=1,  oy=8}, ['—'] = {x=86,  y=251, w=7, h=3,  ox=1,  oy=5},
    ['’'] = {x=58,  y=251, w=4, h=4,  ox=-1, oy=8}, ['…'] = {x=43,  y=251, w=7, h=4,  ox=1,  oy=3},
    ['€'] = {x=175, y=227, w=7, h=9,  ox=1,  oy=8}, ['←'] = {x=147, y=244, w=7, h=7,  ox=1,  oy=6},
    ['↑'] = {x=154, y=244, w=7, h=7,  ox=1,  oy=6}, ['→'] = {x=161, y=244, w=7, h=7,  ox=1,  oy=6},
    ['↓'] = {x=168, y=244, w=7, h=7,  ox=1,  oy=6}, [' '] = {x=101, y=251, w=7, h=3,  ox=1,  oy=1},
}


local function printt(txt, x, y, ...)
    local t = txt:format(...)

    local vertices = {}
    local indices = {}
    for c in str:gmatch("[\0-\x7F\xC2-\xF4][\x80-\xBF]*") do
        
    end
end