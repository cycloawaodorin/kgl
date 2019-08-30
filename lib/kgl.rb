require "kgl/version"
require "kgl/suu"
require "kgl/kmath"

class Integer
	def to_msm(fps=60)
		s, f = divmod(fps)
		ms = (f*1000).quo(fps).round
		m, s = s.divmod(60)
		%Q|#{m}:#{s}.#{ms}|
	end
end
