##########################
## 데이터 프레임 다루기 ##
##########################

# 행렬과 비슷한 형태이지만 
# 행렬은 같은 형태의 객체를 가지는 반면, 데이터 프레임은 각 열들이 다른 형태의 객체를 가질 수 있다.

# 1. read.table() 함수로 외부데이터 불러오기
data = read.table("C:\\Users\\jieun shin\\Desktop\\example.csv", header = TRUE, sep = ',')
data = read.csv("C:\\Users\\jieun shin\\Desktop\\example.csv", header = TRUE)

data
str(data)  # 데이터의 타입 확인


# 2. 벡터를 결합하여 데이터프레임 만들기: data.frame()
x = rep(LETTERS[1:3], c(2, 2, 1))
y = rep(1:3, c(2, 2, 1))
z = data.frame(x, y)
z


First_name = c("Joe", "Peggy", "Harry", "Joan")
Last_name = c("Sixpack", "Sue", "Henderson", "Jett")
Age = c(32, 27, 38, 35)
Male = c(TRUE, FALSE, TRUE, FALSE)

practice_data = data.frame(First_name, Last_name, Age, Male)
practice_data

practice_data$Age
practice_data$Male


# 3. 타입 형태를 바꾸어 데이터프레임 만들기: as.data.frame()
z1 = letters[1:12]
dim(z1) = c(4, 3)
z2 = as.data.frame(z1)
z2


# 데이터프레임 합치기
cbind(z1, z2)
rbind(z1, z2)

# 열 추가하기
z2$V4 = 1:4
z2

colnames(z2) = c("c1", "c2", "c3", "c4")
z2

# 열 제거하기
z2$c4 = NULL
z2

# 데이터 저장하기
write.csv(z2, "C:\\Users\\jieun shin\\Desktop\\z2.csv")



#########################################
## dplyr 패키지를 활용한 데이터 전처리 ##
#########################################
test1 = data.frame(프랜차이즈명 = rep(c("A", "B", "C"), each = 3),
                   종류 = rep(c("불고기버거", "치즈버거", "치킨버거"), times = 3),
                   가격 = c(3000, 4000, 4500, 3500, 2500, 4000, 5000, 2000, 3000))

test1

library(dplyr)  # 패키지 설치

# 1. select 함수: 변수를 선택할 때 사용
# select(데이터명, 뱐수1, 변수2, 변수3, ...)

select(test1, 프랜차이즈명, 종류)  # 프랜차이즈명, 종류 변수만

select(test1, 프랜차이즈명)        # 프랜차이즈명 변수만


# 2. filter 함수: 조건에 만족하는 데이터를 추출할 때 사용
# filter(데이터명, 조건식)

filter(test1, 가격 >= 4000)

filter(test1, 가격 <= 3000)

filter(test1, 가격 == 3000)

filter(test1, 가격 >= 4000 | 가격 <= 2000)

filter(test1, 가격 >= 4000 & 종류 == "치즈버거")

filter(test1, 가격 >= 4000 & (프랜차이즈명 == "A" | 프랜차이즈명 == "B"))

filter(test1, 가격 >= 4000 & 프랜차이즈명 %in% c("A", "B"))


# 3. 파이프라인 %>% 사용법
# 데이터셋 %>% 사용할 함수 %>% 사용할 함수 %>% ...

test1 %>% select(프랜차이즈명, 종류)

test1 %>% filter(가격 >= 4000)

test1 %>% filter(가격 >= 4000 & 종류 == "치즈버거")

# 4. group_by와 summerise 함수: 그룹별 요약통계량 계산

test1 %>% group_by(종류) %>% summarise(mean(가격))


test1 %>% group_by(종류) %>% summarise(mean(가격),
                                         sd(가격),
                                         median(가격),
                                         max(가격),
                                         min(가격))


test1 %>% group_by(종류) %>% summarise(평균 = mean(가격),
                                       표준편차 = sd(가격),
                                       중앙값 = median(가격),
                                       최댓값 = max(가격),
                                       최솟값 = min(가격))


# 5. arrange 함수: 데이터를 정렬할 때 사용한다.
# arrange(데이터셋, 변수)
test1 %>% arrange(., 가격)

test1 %>% arrange(., desc(가격))

test1 %>% tibble::rownames_to_column('구분') %>% arrange(., 가격)

# 6. mutate 함수: 변수 추가하기
test2 = test1 %>% arrange(가격) %>% mutate(구분 = row.names(test1))

test2 %>% select(구분, 가격, 프랜차이즈명, 종류)  # 변수 순서 바꿈

# 매장 별 할인가격 변수 생성
# A:10%, B:15%, C:20% 할인
sale = data.frame(프랜차이즈명 = c("A", "B", "C"),
                  할인율 = c(0.1, 0.15, 0.2))

sale

test3 = merge(test1, sale)

test3 %>% mutate(할인가격 = 가격*(1-할인율))






