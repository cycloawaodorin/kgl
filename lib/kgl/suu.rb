# 整数を日本語等で表した時の文字列(self<0ならnil)を返すメソッド Integer#express を提供する。
# 補助的に使用する定数や関数は Integer::SuuConstantsAndSubFunctions モジュールで定義されている。
# Integer クラスでこのモジュールを include している。
# 第一引数 lang には文字列を与える。
# lang の先頭の文字(大文字小文字問わず)でどの言語に変換するかを判断する。
# 以下，変換可能な言語とその補足説明を記す。
# d: 十進位取り
#   ただの Integer#to_s 。
# f: 浮動小数点数
#   第二引数 acc を使用する。
#   ほぼ "%1.#{acc-1}e" % self.to_f と同じだが，Floatの範囲外の大きな整数でも使える。
#   acc が1未満の場合は ArgumentError を発生。
# j: 日本語
#   一般に用いられる万進法による中数である。極以上を万万進とすることや，無量大数を分けることはしない。
#   千～においては省略しないこともままあるが，ここでは十，百，千～の位が1のとき一の文字を省略する。
#   千無量大数の十倍以上の数は表わせないので RangeError を発生。
#   参考：無量大数の彼方へ(http://www.sf.airnet.ne.jp/ts/language/largenumber.html)
# m: 中数(万万進)。
#   日本語のように十，百，千～の位が1のとき一の文字を省略するのか定かでないが，ここでは省略しないことにした。
#   一千万無量大数の十倍以上の数は表わせないので RangeError を発生。
#   参考：無量大数の彼方へ(http://www.sf.airnet.ne.jp/ts/language/largenumber.html)
# a: 英語(アメリカ式)
# b: 英語(ヨーロッパ式)
#   参考：Name of a Number(http://isthe.com/chongo/tech/math/number/number.html)
class Integer
	module SuuConstantsAndSubFunctions
		Ichi = ['零', '一', '二', '三', '四', '五', '六', '七', '八', '九'].freeze
		Juu = ['', '十', '百', '千'].freeze
		Man = ['', '万', '億', '兆', '京', '垓', '杼', '穣', '溝', '澗', '正', '載', '極',
			'恒河沙', '阿僧祇', '那由他', '不可思議', '無量大数'].freeze
		Mi = ['', 'm', 'b', 'tr', 'quadr', 'quint', 'sext', 'sept', 'oct', 'non'].freeze
		Un = ['', 'un', 'do', 'tre', 'quattuor', 'quin', 'sex', 'septen', 'octo', 'novem'].freeze
		Gin = ['', 'dec', 'vigin', 'trigin', 'quadragin', 'quinquagin',
			'sexagin', 'septuagin', 'octogin', 'nonagin'].freeze
		Cen = ['', 'cen', 'ducen', 'trecen', 'quadringen', 'quingen',
			'sescen', 'septingen', 'octingen', 'nongen'].freeze
		One = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine','ten', 'eleven',
			'twelve', 'thirteen', 'forteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'].freeze
		Ten = ['', 'ten', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'].freeze
		module_function
		def us(p)
			if p == -1
				''
			elsif p == 0
				'thousand'
			elsif p < 1000
				ret = ''
				if p < 10
					ret = Mi[p] + 'illion' + ret
				else
					z = p.to_s
					z = '0' + z if z.length == 2
					if z[1..2].to_i < 10
						ret = Un[z[2..2].to_i] + 'tillion' + ret
					elsif z[1..2].to_i < 20
						ret = Un[z[2..2].to_i] + 'decillion' +  ret
					else
						ret = Un[z[2..2].to_i] + Gin[z[1..1].to_i] + 'tillion' + ret
					end
					ret = Cen[z[0..0].to_i] + ret
				end
				ret
			else
				c = p.to_s
				ret = ''
				x = c[-3, 3]
				if x[1..2].to_i < 10
					ret = Un[x[2..2].to_i] + 'tillion' + ret
				elsif x[1..2].to_i < 20
					ret = Un[x[2..2].to_i] + 'decillion' +  ret
				else
					ret = Un[x[2..2].to_i] + Gin[x[1..1].to_i] + 'tillion' + ret
				end
				ret = Cen[x[0..0].to_i] + ret
				c = c[0..-4]
				m = 1
				while x = c[-3, 3]
					ret = 'millia'*m + ret
					ret = Un[x[2..2].to_i] + (x[1..2].to_i<10 ? '' : Gin[x[1..1].to_i]) + ret
					ret = Cen[x[0..0].to_i] + ret
					c = c[0..-4]
					m += 1
				end
				if c != ''
					ret = 'millia'*m + ret
					if c.length == 1
						c = '00' + c
					elsif c.length == 2
						c = '0' + c
					end
					ret = Un[c[2..2].to_i] + (c[1..2].to_i<10 ? '' : Gin[c[1..1].to_i]) + ret if c != '001'
					ret = Cen[c[0..0].to_i] + ret
				end
				ret
			end
		end
		def gb(p)
			c = p.div(2)
			suf = (p%2==0 ? 'on' : 'ard')
			if c == 0
				p%2 == 0 ? '' : 'thousand'
			elsif c < 1000
				ret = ''
				if c < 10
					ret = Mi[c] + 'illi' + suf + ret
				else
					z = c.to_s
					z = '0' + z if z.length == 2
					if z[1..2].to_i<10
						ret = Un[z[2..2].to_i] + 'tilli' + suf + ret
					elsif z[1..2].to_i < 20
						ret = Un[z[2..2].to_i] + 'decilli' + suf + ret
					else
						ret = Un[z[2..2].to_i] + Gin[z[1..1].to_i] + 'tilli' + suf + ret
					end
					ret = Cen[z[0..0].to_i] + ret
				end
				ret
			else
				c = c.to_s
				ret = ''
				x = c[-3, 3]
				if x[1..2].to_i < 10
					ret = Un[x[2..2].to_i] + 'tilli' + suf + ret
				elsif x[1..2].to_i < 20
					ret = Un[x[2..2].to_i] + 'decilli' + suf + ret
				else
					ret = Un[x[2..2].to_i] + Gin[x[1..1].to_i] + 'tilli' + suf + ret
				end
				ret = Cen[x[0..0].to_i] + ret
				c = c[0..-4]
				m = 1
				while x = c[-3, 3]
					ret = 'millia'*m + ret
					ret = Un[x[2..2].to_i] + (x[1..2].to_i<10 ? '' : Gin[x[1..1].to_i]) + ret
					ret = Cen[x[0..0].to_i] + ret
					c = c[0..-4]
					m += 1
				end
				if c != ''
					ret = 'millia'*m + ret
					if c.length == 1
						c = '00' + c
					elsif c.length == 2
						c = '0' + c
					end
					ret = Un[c[2..2].to_i] + (c[1..2].to_i<10 ? '' : Gin[c[1..1].to_i]) + ret if c != '001'
					ret = Cen[c[0..0].to_i] + ret
				end
				ret
			end
		end
	end
	include SuuConstantsAndSubFunctions
	def express(lang='j', acc=7)
		raise RangeError, 'negative integer' if self < 0
		ni = self.to_s
		ret = ''
		case lang
		when /^d/i #decimal
			ret = ni
		when /^f/i #float
			raise ArgumentError, 'nonpositive float accuracy' if acc < 1
			p = ni.length - 1
			d = ni[0, acc+1]
			while d.length < acc+1
				d += '0'
			end
			d = d.to_i.div(10) + (((d.to_i%10)<5) ? 0 : 1)
			if d >= 10**acc
				d = d.div(10)
				p += 1
			end
			d = d.to_s
			d[1, 0] = '.'
			ret = "#{d}e+#{p}"
		when /^j/i #Japanese
			return Ichi[0] if self==0
			raise RangeError, 'too large for Japanese' if self >= 10**72
			m = 0
			while x = ni[-4, 4]
				ret = Man[m] + ret if x != '0000'
				0.upto(3){|i|
					ret = ((i!=0 && x[3-i, 1]=='1') ? '' : Ichi[x[3-i, 1].to_i]) + Juu[i] + ret if x[3-i, 1] != '0'
				}
				ni = ni[0..-5]
				m += 1
			end
			if ni != ''
				ret = Man[m] + ret
				x = ni.reverse.split(//)
				ret = Ichi[x[0].to_i] + ret if x[0] != '0'
				1.upto(2){|i|
					ret = (x[i]=='1' ? '' : Ichi[x[i].to_i]) + Juu[i] + ret if x[i] && x[i] != '0'
				}
			end
		when /^m/i #manmanshinhou
			return Ichi[0] if self==0
			raise RangeError, 'too large for manmanshinnhou' if self >= 10**136
			m = 0
			while x = ni[-8, 8]
				ret = Man[m] + ret if x != '00000000'
				0.upto(3){|i|
					ret = Ichi[x[7-i, 1].to_i] + Juu[i] + ret if x[7-i, 1] != '0'
				}
				ret = Man[1] + ret if x != '0000'
				0.upto(3){|i|
					ret = Ichi[x[3-i, 1].to_i] + Juu[i] + ret if x[3-i, 1] != '0'
				}
				ni = ni[0..-9]
				m = 1 if m == 0
				m += 1
			end
			if ni != ''
				ret = Man[m] + ret
				x = ni.reverse.split(//)
				0.upto(3){|i|
					ret = Ichi[x[i].to_i] + Juu[i] + ret if x[i] && x[i] != '0'
				}
				ret = Man[1] + ret if x[4]
				0.upto(2){|i|
					ret = Ichi[x[4+i].to_i] + Juu[i] + ret if x[4+i] && x[4+i] != '0'
				}
			end
		when /^a/i #American
			return One[0] if self==0
			m = -1
			while x = ni[-3, 3]
				ret = us(m) + ' ' + ret if x != '000'
				if x[1..2].to_i < 20
					ret = One[x[1..2].to_i] + ' ' + ret if x[1..2] != '00'
					ret = One[x[0, 1].to_i] + ' hundred ' + ret if x[0, 1] != '0'
				else
					ret = One[x[2, 1].to_i] + ' ' + ret if x[2, 1] != '0'
					ret = Ten[x[1, 1].to_i] + ' ' + ret if x[1, 1] != '0'
					ret = One[x[0, 1].to_i] + ' hundred ' + ret if x[0, 1] != '0'
				end
				ni = ni[0..-4]
				m += 1
			end
			if ni != ''
				ret = us(m) + ' ' + ret
				x = ni.reverse.split(//)
				if x[1] == '1'
					ret = One[(x[1]+x[0]).to_i] + ' ' + ret
				else
					ret = One[x[0].to_i] + ' ' + ret if x[0] != '0'
					ret = Ten[x[1].to_i] + ' ' + ret if x[1] && x[1] != '0'
				end
				ret = One[x[2].to_i] + ' hundred ' + ret if x[2] && x[2] != '0'
			end
		when /^b/i #British
			return One[0] if self==0
			m = 0
			while x = ni[-3, 3]
				ret = gb(m) + ' ' + ret if x != '000'
				if x[1..2].to_i < 20
					ret = One[x[1..2].to_i] + ' ' + ret if x[1..2] != '00'
					ret = One[x[0, 1].to_i] + ' hundred ' + ret if x[0, 1] != '0'
				else
					ret = One[x[2, 1].to_i] + ' ' + ret if x[2, 1] != '0'
					ret = Ten[x[1, 1].to_i] + ' ' + ret if x[1, 1] != '0'
					ret = One[x[0, 1].to_i] + ' hundred ' + ret if x[0, 1] != '0'
				end
				ni = ni[0..-4]
				m += 1
			end
			if ni != ''
				ret = gb(m) + ' ' + ret
				x = ni.reverse.split(//)
				if x[1] == '1'
					ret = One[(x[1]+x[0]).to_i] + ' ' + ret
				else
					ret = One[x[0].to_i] + ' ' + ret if x[0] != '0'
					ret = Ten[x[1].to_i] + ' ' + ret if x[1] && x[1] != '0'
				end
				ret = One[x[2].to_i] + ' hundred ' + ret if x[2] && x[2] != '0'
			end
		end
		while ret[-1, 1] == ' '
			ret = ret[0..-2]
		end
		ret
	end
end
