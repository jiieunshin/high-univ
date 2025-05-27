# 패키지 불러오기
library(readr)
library(dplyr)
library(corrplot)
library(MASS)

setwd("C:/Users/user/OneDrive/바탕 화면")

# 1. 데이터 불러오기
df <- read.table("fire_reason.txt", sep = ",", header = T)

# -------------------------------
# 이변량 분석을 위한 데이터 전처리
# -------------------------------
# 범주형: 연도, 시군구명 / 수치형: 나머지 원인별 화재 건수
num_data <- df %>% 
  dplyr::select(-연도, -시군구명)

# -------------------------------
# 상관 행렬 계산 및 시각화
# -------------------------------
cor_matrix <- cor(num_data)

# 상관계수 출력
print(round(cor_matrix, 2))

# 상관 행렬 그림
corrplot(cor_matrix, method = "color", type = "upper", tl.cex = 0.8, 
         addCoef.col = "black")

# -------------------------------
# 이변량 산점도 행렬
# -------------------------------
pairs(num_data, main = "이변량 산점도 행렬", pch = 20, cex.labels = 1.2)

# -------------------------------
# 작동기기 vs 다른 변수들과의 산점도
# -------------------------------
par(mfrow = c(2, 2))  # 2행 3열 그래프 레이아웃
plot(num_data$작동기기, num_data$미상.발화원인., xlab="작동기기", ylab="미상(발화원인)", main="작동기기 vs 미상")
plot(num_data$작동기기, num_data$불꽃..불티, xlab="작동기기", ylab="불꽃/불티", main="작동기기 vs 불꽃/불티")
plot(num_data$작동기기, num_data$담뱃불..라이터불, xlab="작동기기", ylab="담뱃불/라이터불", main="작동기기 vs 담뱃불")
plot(num_data$작동기기, num_data$마찰..전도..복사, xlab="작동기기", ylab="마찰/전도/복사", main="작동기기 vs 마찰")
par(mfrow = c(1, 1))  # 레이아웃 초기화

# -------------------------------
# 연도별 작동기기 건수 지역별 선 그래프
# -------------------------------

# 고유 지역명 중에서 1, 3, 5, 7, 9번째 선택
city_list <- unique(df$시군구명)[c(1, 3, 5, 7, 9)]
colors <- rainbow(length(city_list))

# 빈 plot 설정
plot(NULL, xlim = range(df$연도), ylim = range(df$작동기기), 
     xlab = "연도", ylab = "작동기기 화재 건수", 
     main = "지역별 작동기기 화재 추이")

# 각 지역별로 꺾은선 그래프 그리기
for (i in seq_along(city_list)) {
  sub_df <- df[df$시군구명 == city_list[i], ]
  lines(sub_df$연도, sub_df$작동기기, type = "b", col = colors[i], pch = 19)
}

# 범례 추가
legend("topright", legend = city_list, col = colors, pch = 19, lty = 1, cex = 0.8)

# 평균 선 그래프 겹쳐 그리기
year_avg <- df[df$시군구명 %in% city_list, ] %>%
  group_by(연도) %>%
  summarise(avg_device = mean(작동기기))

points(year_avg$연도, year_avg$avg_device, lty = 2, lwd = 2, type = "b", pch = 19, col = "black",
       xlab = "연도", ylab = "평균 작동기기 화재 건수", main = "연도별 작동기기 화재 추이(모든 평균")
