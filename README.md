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

### `Integer#to_msm(fps=60)`
Returns `"[minutes]:[seconds].[milliseconds]"` which corresponds to `self` frames.
The submilliseconds will be rounded. `fps` is frames per second.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the KGL project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cycloawaodorin/kgl/blob/master/CODE_OF_CONDUCT.md).
