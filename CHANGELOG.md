# Change Log

## 0.0.6 2026/04/13
- Add `Rational#approx_reduction` and refine `Float#to_r` by using this method.

## 0.0.5 2026/04/12
- `Float#to_r` and `Float#to_r_exact` raise `FloatDomainError` when `self` is not finite.

## 0.0.4 2026/04/02
- Add `Float#to_r_exact` that returns exact Rational value expressed by `self`.

## 0.0.3 2024/12/03
- Add `Kgl.#rpw`.

## 0.0.2 2020/04/23
- Change default value of the `Integer#to_msm`'s argument to `59.94`.

## 0.0.1 2019/08/31
- First release.
