# 데이터 출처: https://www.kaggle.com/code/fahadmehfoooz/rain-prediction-with-90-65-accuracy/input
# 호주 여러 기상 관측소에서 약 10년간의 일일 기상 관측 데이터
#
# RainTomorrow는 예측 대상 변수입니다. 즉, 다음 날 비가 왔는지(예 또는 아니요)를 의미합니다.
# 이 열은 해당 날의 강수량이 1mm 이상인 경우 '예'입니다.

# ------------------ 패키지 설치 및 로딩 ------------------
install.packages("naniar")

library(ggplot2)
library(dplyr)
library(naniar)
library(gridExtra)
library(corrplot)
library(class)

# ------------------ 데이터 불러오기 및 전처리 ------------------
weather <- read.csv("C:/Users/user/OneDrive/바탕 화면/weatherAUS.csv")
weather$Rain.Tomorrow <- as.factor(weather$Rain.Tomorrow)
train_data$p
# 결측치 확인
round(colSums(is.na(weather)) / nrow(weather), 3)

gg_miss_var(weather) +
  labs(title = "변수별 결측치 개수")

# 숫자형 변수 평균으로 NA 채우기
num_cols <- sapply(weather, is.numeric)

weather[, num_cols] <- lapply(weather[, num_cols], function(x) {
  ifelse(is.na(x), mean(x, na.rm = TRUE), x)
})

# 최빈값 구하는 함수
get_mode <- function(v) {
  uniqv <- unique(na.omit(v))
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# 범주형 변수 최빈값으로 NA 채우기
cat_cols <- sapply(weather, is.character)

weather[, cat_cols] <- lapply(weather[, cat_cols], function(x) {
  x[is.na(x)] <- get_mode(x)
  return(x)
})

# ------------------ EDA: 시각화 ------------------

# 1. RainToday, RainTomorrow 카운트 플롯
p1 <- ggplot(weather, aes(x = factor(RainToday))) + 
  geom_bar() + 
  ggtitle("Count of RainToday") + 
  xlab("RainToday") + 
  ylab("Count")

p2 <- ggplot(weather, aes(x = factor(RainTomorrow))) + 
  geom_bar() + 
  ggtitle("Count of RainTomorrow") + 
  xlab("RainTomorrow") + 
  ylab("Count")

grid.arrange(p1, p2, ncol = 2)

# 2. 바람 방향 (WindDir9am, WindDir3pm, WindGustDir) 카운트 플롯
p3 <- ggplot(weather, aes(x = factor(WindDir9am))) + 
  geom_bar() + 
  ggtitle("Wind Direction at 9am") + 
  xlab("WindDir9am") + 
  ylab("Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

p4 <- ggplot(weather, aes(x = factor(WindDir3pm))) + 
  geom_bar() + 
  ggtitle("Wind Direction at 3pm") + 
  xlab("WindDir3pm") + 
  ylab("Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

p5 <- ggplot(weather, aes(x = factor(WindGustDir))) + 
  geom_bar() + 
  ggtitle("Wind Gust Direction") + 
  xlab("WindGustDir") + 
  ylab("Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

grid.arrange(p3, p4, p5, ncol = 1)

# 3. Heatmap (상관관계 시각화)
# 숫자형 변수만 선택
num_vars <- weather[, sapply(weather, is.numeric)]

# 상관행렬 계산
cor_mat <- cor(num_vars, use = "complete.obs")

# 히트맵 출력
corrplot(cor_mat,
         method = "color",   # 색상으로 표시
         type = "upper",     # 상삼각만 표시
         tl.cex = 0.7,       # 텍스트 크기
         addCoef.col = "black",  # 상관계수 숫자를 검정색으로 표시
         number.cex = 0.7)       # 숫자 크기 조절


# 4. 4. Boxplots: 습도(Humidity)와 기압(Pressure)
p6 <- ggplot(weather, aes(y = Humidity3pm)) + 
  geom_boxplot(fill = "cyan") + 
  ggtitle("Boxplot of Humidity at 3pm")

p7 <- ggplot(weather, aes(y = Humidity9am)) + 
  geom_boxplot(fill = "cyan") + 
  ggtitle("Boxplot of Humidity at 9am")

p8 <- ggplot(weather, aes(y = Pressure3pm)) + 
  geom_boxplot(fill = "orange") + 
  ggtitle("Boxplot of Pressure at 3pm")

p9 <- ggplot(weather, aes(y = Pressure9am)) + 
  geom_boxplot(fill = "orange") + 
  ggtitle("Boxplot of Pressure at 9am")

grid.arrange(p6, p7, p8, p9, nrow = 1, ncol = 4)


# 5. Violin plot: RainToday에 따른 MaxTemp, MinTemp (RainTomorrow로 색상 구분)
p10 <- ggplot(weather, aes(x = factor(RainToday), y = MaxTemp, fill = factor(RainTomorrow))) + 
  geom_violin() + 
  ggtitle("MaxTemp by RainToday and RainTomorrow") + 
  xlab("RainToday") + 
  ylab("MaxTemp")

p11 <- ggplot(weather, aes(x = factor(RainToday), y = MinTemp, fill = factor(RainTomorrow))) + 
  geom_violin() + 
  ggtitle("MinTemp by RainToday and RainTomorrow") + 
  xlab("RainToday") + 
  ylab("MinTemp")

grid.arrange(p10, p11, ncol = 1)

# ----------------------------------------------------
# ------------------ 예측 모델 예제 ------------------
# ----------------------------------------------------

# 모델 학습을 위한 데이터 처리 -----------------------
weather <- weather %>%
  mutate(across(where(is.character), as.factor))

weather <- weather[, -1]

# 1) 데이터 섞고 70:30 분할
n <- nrow(weather)
idx <- sample(seq_len(n), size = 0.7 * n)
train_data <- weather[idx, ]
test_data  <- weather[-idx, ]

# 1) 모델에 사용된 변수 확인 (factor 변수만 골라내기)
factor_vars <- names(Filter(is.factor, train_data))

# 2) 각 factor 변수별로 test_data 수준을 train_data 수준에 맞춤
for (var in factor_vars) {
  test_data[[var]] <- factor(test_data[[var]], levels = levels(train_data[[var]]))
}

# 3) 새로운 수준이 포함된 행 제거 (NA 발생 행 제거)
test_data <- na.omit(test_data)
train_data <- na.omit(train_data)
rm(weather)

# test dataset 완성
test_data <- match_factor_levels(test_data, train_data)


# 선형 회귀모형 적합 ----------------------------------
# 모든 변수 사용 (MaxTemp 예측용 변수 모두 사용 예시)

lm_model <- lm(MaxTemp ~ ., data = train_data)
summary(lm_model)

# Test 데이터 예측
test_data$predicted_MaxTemp <- predict(lm_model, newdata = test_data)

# 결과: 산점도와 적합 선
ggplot(test_data, aes(x = MaxTemp, y = predicted_MaxTemp)) +
  geom_point(alpha = 0.5) +
  geom_abline(color = "red") +
  labs(title = "Actual vs Predicted MaxTemp (Test Data)", x = "Actual MaxTemp", y = "Predicted MaxTemp") +
  theme_minimal()

# 로지스틱 회귀: 내일 비가올지 예측 ------------------
glm_full <- glm(RainTomorrow ~ .,
                data = train_data, family = binomial)

summary(glm_full)

# Test 데이터 예측 확률 및 클래스 (전체 변수 사용)
prob_new <- predict(glm_full, newdata = test_data, type = "response")
class_new <- ifelse(prob_full > 0.5, "Yes", "No")

table(test_data$RainTomorrow, class_new)

# KNN: 내일 비가올지 예측 --------------------------------------------
train_X <- train_data[, sapply(train_data, is.numeric)]
train_y <- train_data$RainTomorrow

test_X <- test_data[, sapply(test_data, is.numeric)]

pred_knn <- knn(train = train_X, test = test_X, cl = train_y, k = 5)

table(test_data$RainTomorrow, pred_knn)

# knn 시각화 ---------------------------------------------------------
# (3) 시각화용 변수 선택
x_var <- "Sunshine"
y_var <- "Humidity9am"

x_range <- range(test_data[[x_var]], na.rm = TRUE)
y_range <- range(test_data[[y_var]], na.rm = TRUE)

grid <- expand.grid(
  x = seq(x_range[1], x_range[2], length.out = 200),
  y = seq(y_range[1], y_range[2], length.out = 200)
)
colnames(grid) <- c(x_var, y_var)

# grid에 있는 나머지 변수는 평균값으로 채워야 함
grid_full <- as.data.frame(matrix(ncol = ncol(train_X), nrow = nrow(grid)))
colnames(grid_full) <- colnames(train_X)

# 두 변수만 grid에서 사용, 나머지는 평균으로
for (var in colnames(train_X)) {
  if (var == x_var || var == y_var) {
    grid_full[[var]] <- grid[[var]]
  } else {
    grid_full[[var]] <- mean(train_X[[var]], na.rm = TRUE)
  }
}

# grid에 대해 예측
grid_pred <- knn(train = train_X, test = grid_full, cl = train_y, k = 5)
grid$pred <- grid_pred
grid$pred_num <- ifelse(grid$pred == "Yes", 1, 0)

# 시각화
ggplot() +
  geom_tile(data = grid, aes_string(x = x_var, y = y_var, fill = "pred"), alpha = 0.2) +
  geom_point(data = test_data, aes_string(x = x_var, y = y_var, color = "RainTomorrow"),
             size = 1, alpha = 0.2) +
  scale_fill_manual(values = c("No" = "skyblue", "Yes" = "tomato"), name = "kNN Prediction") +
  scale_color_manual(values = c("No" = "blue", "Yes" = "red"), name = "Actual") +
  labs(
    title = "k-NN Decision Boundary (Visualization using 2 Variables)",
    subtitle = paste("Variables:", x_var, "vs", y_var)
  ) +
  theme_minimal()
