class << Math
	alias ln log
end
module Math
	alias ln log
	module_function
	def log(base, anti_logarithm=base.tap{base=nil})
		if base.nil?
			ln(anti_logarithm)
		else
			ln(anti_logarithm).quo(ln(base))
		end
	end
	def lg(anti_logarithm)
		log(2.0, anti_logarithm)
	end
end

class Rational
	protected def kglsize
		[self.numerator.abs, self.denominator].min
	end
	protected def kgldiff(other)
		(self-other).abs
	end
	def approx_reduction(dig=8, depth=16, org=self)
		return self if depth <= 0
		self.to_f rescue return self
		ret, app = self, self
		if (1<<(dig*2)) < self.kglsize
			1.upto(1<<dig) do |i|
				[[0, i], [0, -i], [i, 0], [-i, 0]].each do |n, d|
					q = Rational(numerator+n, denominator+d)
					if q.kglsize < ret.kglsize
						if q.kgldiff(org) <= ret.kgldiff(org)
							ret = q 
						elsif q.kglsize < app.kglsize
							app = q
						end
					end
				end
				1.upto(i) do |j|
					[[j, i], [j, -i], [-j, i], [-j, -i]].each do |a, b|
						q = Rational(numerator+a, denominator+b)
						if q.kglsize < ret.kglsize
							if q.kgldiff(org) <= ret.kgldiff(org)
								ret = q 
							elsif q.kglsize < app.kglsize
								app = q
							end
						end
						q = Rational(numerator+b, denominator+a)
						if q.kglsize < ret.kglsize
							if q.kgldiff(org) <= ret.kgldiff(org)
								ret = q 
							elsif q.kglsize < app.kglsize
								app = q
							end
						end
					end
				end
			end
		end
		if ret.kglsize < self.kglsize
			ret.approx_reduction(dig, depth-1, org)
		else
			app.approx_reduction(dig, depth-1, org)
		end
	end
end

class Float
	def to_r(dig=8)
		r = self.to_r_exact
		q = r.approx_reduction(dig)
		q.to_f == self ? q : r
	end
	def to_r_exact
		raise FloatDomainError, self.inspect unless self.finite?
		s, e = Math.frexp(self)
		if e < MANT_DIG
			Rational(Math.ldexp(s, MANT_DIG).to_i, 1<<(MANT_DIG-e))
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
