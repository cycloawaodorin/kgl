require "kgl/version"
require "kgl/suu"
require "kgl/kmath"

class Integer
	def to_msm(fps=59.94)
		s, f = divmod(fps)
		ms = (f*1000).quo(fps).round
		m, s = s.divmod(60)
		%Q|#{m}:#{s}.#{ms}|
	end
end

module Kgl
	module_function def rpw(n, sym='!#$%&*+,-./:;<=>?@')
		ls = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' + sym
		m = ls.length
		`openssl rand #{n}`.bytes.map do |i|
			while m <= i
				i = `openssl rand 1`.bytes[0]
			end
			ls[i]
		end.join
	rescue Errno::ENOENT => e
		raise 'Kgl.#rpw requires openssl command'
	end
end
