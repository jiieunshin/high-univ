# 사용할 데이터셋: mtcars
# 자동차 연비(mpg), 기통 (cyl), 출력 (hp), 중량 (wt)
# 자동차 중량(wt)과 연비(mpg)의 관계를 분석하기

# 각 데이터 정리
y = mtcars$wt
x = mtcars$hp

plot(x, y, pch = 16, main = "자동차중량대비 연비 산점도", xlab = "자동차중량", ylab = "연비")

# 상관계수
cor(x, y)


