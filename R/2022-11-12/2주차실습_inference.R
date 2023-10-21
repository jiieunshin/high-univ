# 통계적 추론
# 1. marks 데이터를 활용해보자

marks = c(7, 59, 78, 79, 60, 65, 68, 71, 75, 48, 51, 55, 56, 41, 43, 44, 75, 78, 80, 81, 83, 83, 85,
          48, 49, 49, 30, 30, 31, 32, 35, 37, 41, 86, 42, 51, 53, 56, 42, 44, 50, 51, 65, 67, 51, 56, 58, 64, 64, 75)

female = marks[1:23]     # 23개
male = marks[24:50]  # 27개를 모집단이라고 생각해보자

# 2. 모집단의 평균, 분산을 계산
mean(male); var(male)
mean(female); var(female)

# 3. 표본추출
# 각각 10개의 샘플을 뽑기 (표본)
male_s = sample(male, 10)
female_s = sample(female, 10)

# 표본의 평균, 분산을 계산
mean(male_s); var(male_s)
mean(female_s); var(female_s)


# 4. 히스토그램을 비교
# 모집단의 히스토그램
# male_s = sample(male, 10)
# female_s = sample(female, 10)
# 
# female_s_CI = mean(female_s) + c(-1, 1) * 1.96 * sd(female_s) / sqrt(10)
# male_s_CI = mean(male_s) + c(-1, 1) * 1.96 * sd(male_s) / sqrt(10)

par(mfrow = c(2, 1))
hist(female, col = adjustcolor("red", alpha = 0.5), main = "모집단" , freq = FALSE)  # 성별 구분한 히스토그램
hist(male, col = adjustcolor("blue", alpha = 0.5), freq = FALSE, add = TRUE)

points(mean(female), 0, col = "red", pch = 16)
points(mean(male), 0, col = "blue", pch = 16)

# 표본집단의 히스토그램
hist(female_s, col = adjustcolor("red", alpha = 0.5), main = "표본집단", breaks = 8, freq = FALSE)  # 성별 구분한 히스토그램
hist(male_s, col = adjustcolor("blue", alpha = 0.5), freq = FALSE, breaks = 8, add = TRUE)

points(mean(female_s), 0, col = "red", pch = 16)
points(mean(male_s), 0, col = "blue", pch = 16)

points(female_s_CI, c(0, 0), type = "l", lwd = 2, col = "red")
points(male_s_CI, c(0, 0), type = "l", lwd = 2, col = "blue")

par(mfrow = c(1, 1))


# 5. 구간추정
mean(female_s) + c(-1, 1) * 1.96 * sd(female_s) / sqrt(10)
mean(male_s) + c(-1, 1) * 1.96 * sd(male_s) / sqrt(10)
