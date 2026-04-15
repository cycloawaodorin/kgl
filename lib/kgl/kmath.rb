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
	def approx_reduction(all=false)
		if self.numerator == 0
			return self unless all
			d = 0
			d += 1 while Rational(1, 1<<d).to_f != 0.0
			n = 1<<d
			(d-1).downto(0) do |i|
				e = (1<<i)
				n -= e if Rational(1, n-e).to_f == 0.0
			end
			return [Rational(-1, n), Rational(1, n)]
		elsif self.denominator == 1
			s = self < 0 ? -1 : 1
			d, n = 0, self.numerator.abs
			f = n.to_f
			d += 1 while (n-(1<<d)).to_f == f
			(d-1).downto(0) do |i|
				e = (1<<i)
				n -= e if (n-e).to_f == f
			end
			r = Rational(n*s, 1)
			return r unless all
			d, n = 0, self.numerator.abs
			d += 1 while (n+(1<<d)).to_f == f
			(d-1).downto(0) do |i|
				e = (1<<i)
				n += e if (n+e).to_f == f
			end
			if n == r.numerator.abs
				return [r]
			else
				return [r, Rational(n*s, 1)]
			end
		elsif self.numerator.abs == 1
			d, n = 0, self.denominator
			f = self.to_f.abs
			if f == 0.0
				unless all
					return Rational(0, 1).approx_reduction(true)[self.numerator<0 ? 0 : 1]
				else
					return Rational(0, 1).approx_reduction(true)
				end
			end
			d += 1 while Rational(1, n-(1<<d)).to_f == f
			(d-1).downto(0) do |i|
				e = (1<<i)
				n -= e if Rational(1, n-e).to_f == f
			end
			r = Rational(self.numerator, n)
			return r unless all
			d, n = 0, self.denominator
			d += 1 while Rational(1, n+(1<<d)).to_f == f
			(d-1).downto(0) do |i|
				e = (1<<i)
				n += e if Rational(1, n+e).to_f == f
			end
			if n == r.denominator
				return [r]
			else
				return [r, Rational(self.numerator, n)]
			end
		else
			s = self < 0 ? -1 : 1
			q = self.abs
			if q.denominator < q.numerator
				l = [q.numerator.div(q.denominator), 1]
				h = [l[0]+1, 1]
			else
				h = [1, q.denominator.div(q.numerator)]
				l = [1, h[1]+1]
			end
			res = [Rational(*l)]
			r = Rational(*h)
			foo, bar = (r-q).abs, (res[0]-q).abs
			res = [r] if foo < bar || ( foo == bar && h.min < l.min )
			i = 0
			loop do
				m = [l[0]+h[0], l[1]+h[1]]
				r = Rational(*m)
				if q.denominator <= r.denominator
					return all ? res : res[-1]
				elsif r < q
					l = m
				else
					h = m
				end
				res << r*s if (r-q).abs < (res[-1]-q).abs
			end
		end
	end
end

class Float
	if method_defined?(:to_r)
		alias to_r_exact to_r
	else
		def to_r_exact
			raise FloatDomainError, self.inspect unless self.finite?
			if RADIX == 2
				md = MANT_DIG
			else
				md = (MANT_DIG*Math.lg(RADIX)).floor
			end
			s, e = Math.frexp(self)
			if e < md
				Rational(Math.ldexp(s, md).to_i, 1<<(md-e))
			else
				Rational(self.to_i, 1)
			end
		end
	end
	def to_r
		a = self.abs
		q = a.to_r_exact
		s = (self < 0.0) ? -1 : 1
		if q.denominator < q.numerator
			l = [q.numerator.div(q.denominator), 1]
			r = Rational(*l)
			return r*s if r.to_f == a
			h = [l[0]+1, 1]
			r = Rational(*h)
			return r*s if r.to_f == a
		else
			h = [1, q.denominator.div(q.numerator)]
			r = Rational(*h)
			return r*s if r.to_f == a
			l = [1, h[1]+1]
			r = Rational(*l)
			return r*s if r.to_f == a
		end
		loop do
			m = [l[0]+h[0], l[1]+h[1]]
			r = Rational(*m)
			if r.to_f == a
				return r*s
			elsif r < q
				l = m
			else
				h = m
			end
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
