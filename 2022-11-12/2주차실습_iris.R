#########################################
## dplyr 패키지를 활용한 데이터 전처리 ##
#########################################
# iris 데이터 불러오기
data(iris)

str(iris)

library(dplyr)  # 패키지 설치

# 1. select 함수: 변수를 선택할 때 사용
# select(데이터명, 뱐수1, 변수2, 변수3, ...)

select(iris, Sepal.Length)

select(iris, Sepal.Length, Sepal.Width, Species)  


# 2. filter 함수: 조건에 만족하는 데이터를 추출할 때 사용
# filter(데이터명, 조건식)

filter(iris, Species == "setosa")

filter(iris, Species == "virginica")

filter(iris, Sepal.Length >= 5)

filter(iris, Species == "setosa" & Sepal.Length >= 5)

filter(iris, Species == "setosa" & Sepal.Length >= 5 & Sepal.Width >= 3.5)

filter(iris, Sepal.Length >= 5 & (Species == "setosa" | Species == "virginica"))

filter(iris, Sepal.Length >= 5 & Species %in% c("setosa", "virginica"))




# 3. 파이프라인 %>% 사용법
# 데이터셋 %>% 사용할 함수 %>% 사용할 함수 %>% ...

iris %>% select(Sepal.Length, Sepal.Width)

iris %>% filter(Sepal.Length >= 7 & Petal.Length >= 6)

iris %>% filter(Sepal.Length >= 7 & Petal.Length >= 6 & Petal.Width >= 2)

# 4. group_by와 summerise 함수: 그룹별 요약통계량 계산

iris %>% group_by(Species) %>% summarise(mean(Sepal.Length))


iris %>% group_by(Species) %>% summarise(mean(Sepal.Length),
                                         sd(Sepal.Length),
                                         median(Sepal.Length),
                                         max(Sepal.Length),
                                         min(Sepal.Length))


iris %>% group_by(Species) %>% summarise(평균 = mean(Sepal.Length),
                                         표준편차 = sd(Sepal.Length),
                                         중앙값 = median(Sepal.Length),
                                         최댓값 = max(Sepal.Length),
                                         최솟값 = min(Sepal.Length))


# 5. arrange 함수: 데이터를 정렬할 때 사용한다.
# arrange(데이터셋, 변수)
iris %>% arrange(., Sepal.Length)

iris %>% arrange(., desc(Sepal.Length))

iris %>% tibble::rownames_to_column('붓꽃샘플번호') %>% arrange(., Sepal.Length)

# 6. mutate 함수: 변수 추가하기
iris2 = iris %>% mutate(원래순위 = row.names(iris))

iris2 = iris2 %>% arrange(Sepal.Length) %>% mutate(크기순위 = row.names(iris))

iris2$원래순위 = as.numeric(iris2$원래순위)
iris2$크기순위 = as.numeric(iris2$크기순위)

iris2 %>% select(원래순위, 크기순위, Species, Sepal.Length:Petal.Width) %>% arrange(원래순위)  # 변수 순서 바꿈


# 시각화





