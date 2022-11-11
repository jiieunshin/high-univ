##########
## 회귀 ##
##########
# 사용할 데이터셋: mtcars
# 자동차 연비(mpg), 기통 (cyl), 출력 (hp), 중량 (wt)

# 1. 각 데이터 정리
y = mtcars$mpg
x = mtcars$wt

plot(x, y, pch = 16, main = "자동차중량대비 연비 산점도", xlab = "자동차중량", ylab = "연비")

# 2. 상관계수
cor(x, y)

# 3. 단순회귀 적합선 추가
fit = lm(y ~ x)
summary(fit)
abline(fit, lty = 2, lwd = 2, col = "red")

# abline(a = fit$coefficients[1], b = fit$coefficients[2], lty = 2, lwd = 2, col = "red")
## 식을 추가해보자
a = round(fit$coefficients[1], 4)
b = round(fit$coefficients[2], 4)

text(4.5, 27, labels = paste0("Y =", a, "(+)", b, "*X"), col = "red")

# 4. 여러 변수들의 상관관계
pairs(mtcars[c(1, 2, 4, 6)])

## 옵션을 추가해보자
pairs(~mpg+cyl+hp+wt, mtcars, main = "자동차 특성치 산점행렬도", 
      panel = function(x,y){
        points(x, y, pch = 19, col = "blue")
        abline(lm(y~x), col = 2)
        }
      )   



##########
## 분류 ##
##########
# 사용할 데이터셋: 아이리스
# 꽃받침의 길이 (Petal.Length)와 꽃받침의 너비 (Petal.Width)를 이용해서 꽃의 종을 분류해보자.
library(rpart)
library(dplyr)
library(ggvis)

# 1. 데이터 불러오기
iris

# 2. 데이터 시각화
plot(iris)

iris %>% ggvis(~Petal.Length, ~Petal.Width, fill = ~factor(Species)) %>%
  layer_points()

# 3. 데이터 구조 파악
str(iris)

# 4. 데이터 할당
## 원래 데이터의 70%를 랜덤으로 추출
train_id = sort(sample(1:nrow(iris), nrow(iris) * 0.7 ))

## training / test set 할당하기
train_set = iris[training_sampling,]
train_y = train_set$Species

test_set = iris[-training_sampling,]
test_y = test_set$Species

# 5. 의사결정나무 모형 적합
rpart_m = rpart(Species ~ Petal.Length + Petal.Width, data = train_set)

plot(rpart_m)
text(rpart_m, use.n=TRUE, xpd=TRUE, cex=.8)

# 6. 추정 결과
pred_y = predict(rpart_m, newdata = test_set, type = "class")

table(pred_y, test_y)

