module Math
	alias ln log
	module_function
	def log(base, anti_logarithm=base.tap{base=nil})
		if base.nil?
			ln(angi_logarithm)
		else
			ln(anti_logarithm).quo(ln(base))
		end
	end
	def lg(anti_logarithm)
		log(2, anti_logarithm)
	end
end

class Float
	def to_r
		unless self.finite?
			raise FloatDomainError
		end
		str = self.to_s
		(decimal, power) = str.split(/e/)
		(integer, decimal) = decimal.split(/\./)
		length = decimal.length
		numerator = integer.to_i*10**length+decimal.to_i
		denominator = 10**length
		power = power.to_i
		if power > 0
			numerator *= 10**power
		else
			denominator *= 10**(-power)
		end
		return Rational(numerator, denominator)
	end
	def to_r_exact
		unless self.finite?
			raise FloatDomainError
		end
		s, e = Math.frexp(self)
		if e < 53
			Rational(Math.ldexp(s, 53).to_i, 1<<(53-e))
		else
			Rational(self.to_i, 1)
		end
	end
end
class String
	def to_r
		(numerator, denominator) = self.split(/\//)
		if self.match(/\.|e/)
			return numerator.to_f.to_r / denominator.to_f.to_r
		else
			return Rational(numerator.to_i, denominator.to_i)
		end
	end
end
