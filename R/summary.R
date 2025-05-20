# 패키지 불러오기
library(dplyr)

setwd("C:/Users/user/OneDrive/바탕 화면")

# 1. 데이터 불러오기
df <- read.table("fire_reason.txt", sep = ",", header = T)

# 2. 시군구명 빈도수 (도수분포표)
freq_table <- df %>% count(시군구명, name = "빈도수") %>% arrange(desc(빈도수))
print(freq_table)


# 3. 막대그래프
barplot(height = freq_table$빈도수,
        names.arg = freq_table$시군구명,
        col = "skyblue",
        main = "시군구명 빈도수 - 막대그래프",
        xlab = "시군구명",
        ylab = "빈도수",
        las = 2,            # x축 라벨을 세로로 회전 (las = 2는 수직 회전)
        cex.names = 0.8,    # 글씨 크기 조절
        border = "black")

# 4. 원그래프
pie(freq_table$빈도수, labels = freq_table$시군구명, 
    main = "시군구명 빈도수 - 원그래프", col = rainbow(nrow(freq_table)))

# 5. 줄기잎그림
stem(df$작동기기)

# 6. 히스토그램 및 도수다각형
hist_data <- hist(df$작동기기, breaks = 10, col = "skyblue", border = "black",
                  main = "작동기기 분포 - 히스토그램", xlab = "작동기기 수", 
                  ylab = "빈도수")

# 도수다각형 추가
lines(hist_data$mids, hist_data$counts, type = "o", col = "red", lwd = 2)
legend("topright", legend = "도수다각형", col = "red", lwd = 2)

# 7. 상자그림
mean(df$작동기기)
median(df$작동기기)
mode_value <- as.numeric(names(sort(table(df$작동기기), decreasing = TRUE)[1]))
mode_value

var(df$작동기기)
sd(df$작동기기)
max(df$작동기기)
min(df$작동기기)
range_val <- max(df$작동기기) - min(df$작동기기)
range_val

quantile(df$작동기기, 0.75)
quantile(df$작동기기, 0.25)
IQR(df$작동기기)  # 사분위수 범위

skewness(df$작동기기)
kurtosis(df$작동기기)
summary(df$작동기기)

# 9. 그룹별 상자그림
ggplot(df, aes(x = 시군구명, y = 작동기기)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "시군구별 작동기기 상자그림", x = "시군구명", y = "작동기기") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 10. 상위 5개 시군구의 작동기기 합계 원형 그래프
top5 <- df %>%
  group_by(시군구명) %>%
  summarise(합계 = sum(작동기기)) %>%
  arrange(desc(합계)) %>%
  slice(1:5)

pie(top5$합계, labels = top5$시군구명, 
    col = c("#ff9999", "#66b3ff", "#99ff99", "#ffcc99", "#c2c2f0"),
    main = "상위 5개 구의 작동기기 수치의 원형 그래프")













