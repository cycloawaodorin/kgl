# KGL

A ruby gem for personal use.

## Installation

    $ gem install kgl

## Usage
### `Integer#name(lang)`
Returns the natural number expression for `self` in specific natural language. Available languages are the follows.

|`lang`|Language|
|:-|:-|
|`"j"`|Japanese|
|`"a"`|American English (a billion is `10**9`)|
|`"b"`|British English (a billion is `10**12`)|

### `Math.#ln(anti_logarithm)`
An alias of original `Math.#log`. It returns the natural logarithm of `anti_logarithm`.

### `Math.#log(base, anti_logarithm=base.tap{base=Math::E})`
Returns the logarithm of `anti_logarithm` to base `base`.

### `Math.#lg(anti_logarithm)`
Returns the logarithm of `anti_logarithm` to base 2.

### `Float#to_r`, `String#to_r`
Returns `Rational` value of `self`.

### `Float#to_r_exact`
Returns exact `Rational` value of `self`, that may not be desirable for usual usage.
For instance, (0.1).to_r_exact returns (3602879701896397/36028797018963968) while (0.1).to_r returns (1/10).

### `Rational#approx_reduction(all=false)`
Without the following conditions, this returns `Rational` approximation of `self` with smaller denominator, by using Stern-Brocot tree.
If `all` is true, this returns an `Array` includes all the path to `self`.

When `self==(0/1)` and `all` is false, this returns `self`.

When `self==(0/1)` and `all` is true, this returns a pair of negative and positive `Rational` with least denominator which is converted to `0.0` by `Rational#to_f`. For IEEE 754 compliant environments, the value would be -/+ `Rational(1, (((1<<67)-0x4008)<<1008))`.

When `self.denominator==1` and `all` is false, this returns a `Rational` value with least absolute numerator which is converted to `self.to_f` by `Rational#to_f`.

When `self.denominator==1` and `all` is true, this returns a pair of `Rational`s with least and greatest numerator which are converted to `self.to_f` by `Rational#to_f`.

When `self.numerator.abs==1` and `all` is false, this returns a `Rational` value with least denominator which is converted to `selft.to_f` by `Rational#to_f`.

When `self.numerator.abs==1` and `all` is true, this returns a pair of `Rational`s with least and greatest denominator which are converted to `self.to_f` by `Rational#to_f`.

Returns aprroximately same as `org` `Rational` value with smaller denominator.
This method search for changing numerator and denominator of `self` by within `1<<dig`.
`depth` is the maximum recursive depth of this method.

### `Integer#to_msm(fps=59.94)`
Returns `"[minutes]:[seconds].[milliseconds]"` which corresponds to `self` frames.
The submilliseconds will be rounded. `fps` is frames per second.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the KGL project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cycloawaodorin/kgl/blob/master/CODE_OF_CONDUCT.md).
