//
//  JOBKOREA.m
//  jobsearch
//
//  Created by CHAN on 13. 6. 1..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import "JOBKOREA.h"
#import "AFNetworking.h"

@implementation JOBKOREA

eElementType elementType;

int webLoadCount;

-(id) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.xmlValue = [[NSMutableString alloc] init];
    self.items = [[NSMutableArray alloc] init];
    self.item = [[NSMutableDictionary alloc] init];
    
    self.GIBWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
    [self.GIBWebView setScalesPageToFit:YES];
    [self.GIBWebView setDelegate:self];
    self.webView1 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
    [self.webView1 setScalesPageToFit:YES];
    [self.webView1 setDelegate:self];
    self.webView2 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
    [self.webView2 setScalesPageToFit:YES];
    [self.webView2 setDelegate:self];
    self.webView3 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
    [self.webView3 setScalesPageToFit:YES];
    [self.webView3 setDelegate:self];
    self.webView4 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
    [self.webView4 setScalesPageToFit:YES];
    [self.webView4 setDelegate:self];
    self.webStr = [[NSMutableDictionary alloc] init];
    
    self.GI_Part_No_major = @[@{@"major":@"19999",@"name":@"서비스·교육·금융·유통"}
                              ,@{@"major":@"29999",@"name":@"제조·통신·화학·건설"}
                              ,@{@"major":@"a9999",@"name":@"미디어·광고·문화·예술"}
                              ,@{@"major":@"49999",@"name":@"경영·사무"}
                              ,@{@"major":@"59999",@"name":@"마케팅·무역·유통"}
                              ,@{@"major":@"b9999",@"name":@"영업·고객상담"}
                              ,@{@"major":@"38888",@"name":@"IT·인터넷"}
                              ,@{@"major":@"39999",@"name":@"IT·정보통신"}
                              ,@{@"major":@"d9999",@"name":@"연구개발·설계"}
                              ,@{@"major":@"69999",@"name":@"생산·제조"}
                              ,@{@"major":@"79999",@"name":@"전문·특수직"}
                              ,@{@"major":@"37777",@"name":@"디자인"}
                              ,@{@"major":@"c9999",@"name":@"미디어"}];
    
    self.GI_Part_No = @[@{@"major":@"0",@"depth":@"0",@"name":@"전체"}
                        ,@{@"major":@"19999",@"depth":@"10100",@"name":@"공기업·공공기관·협회"}
                        ,@{@"major":@"19999",@"depth":@"10400",@"name":@"컨설팅·연구·조사"}
                        ,@{@"major":@"19999",@"depth":@"10300",@"name":@"은행·보험·증권·카드"}
                        ,@{@"major":@"19999",@"depth":@"10310",@"name":@"캐피탈·대출"}
                        ,@{@"major":@"19999",@"depth":@"10410",@"name":@"의료·보건·복지"}
                        ,@{@"major":@"19999",@"depth":@"10602",@"name":@"교육·유학·학원"}
                        ,@{@"major":@"19999",@"depth":@"10603",@"name":@"학습지·방문교육"}
                        ,@{@"major":@"19999",@"depth":@"10708",@"name":@"호텔·여행·항공"}
                        ,@{@"major":@"19999",@"depth":@"10800",@"name":@"스포츠·여가·휘트니스"}
                        ,@{@"major":@"19999",@"depth":@"10808",@"name":@"음식료·외식·프랜차이즈"}
                        ,@{@"major":@"19999",@"depth":@"10900",@"name":@"백화점·유통·도소매"}
                        ,@{@"major":@"19999",@"depth":@"10910",@"name":@"무역·상사"}
                        ,@{@"major":@"19999",@"depth":@"11100",@"name":@"회계·세무·법무"}
                        ,@{@"major":@"19999",@"depth":@"11200",@"name":@"부동산·중개·임대"}
                        ,@{@"major":@"19999",@"depth":@"11300",@"name":@"정비·A/S"}
                        ,@{@"major":@"19999",@"depth":@"11400",@"name":@"렌탈·임대·리스"}
                        ,@{@"major":@"19999",@"depth":@"10950",@"name":@"물류·운송·배송"}
                        ,@{@"major":@"19999",@"depth":@"11500",@"name":@"서치펌·헤드헌팅"}
                        ,@{@"major":@"19999",@"depth":@"11600",@"name":@"결혼·예식장·상조"}
                        ,@{@"major":@"19999",@"depth":@"11000",@"name":@"시설관리·경비·아웃소싱·기타"}
                        ,@{@"major":@"29999",@"depth":@"20100",@"name":@"전기·전자·제어"}
                        ,@{@"major":@"29999",@"depth":@"20150",@"name":@"반도체·디스플레이·광학"}
                        ,@{@"major":@"29999",@"depth":@"20170",@"name":@"컴퓨터·하드웨어·장비"}
                        ,@{@"major":@"29999",@"depth":@"20200",@"name":@"기계·기계설비"}
                        ,@{@"major":@"29999",@"depth":@"20210",@"name":@"자동차·조선·철강·항공"}
                        ,@{@"major":@"29999",@"depth":@"20220",@"name":@"금속·재료·자재"}
                        ,@{@"major":@"29999",@"depth":@"20306",@"name":@"건설·시공·토목·조경"}
                        ,@{@"major":@"29999",@"depth":@"20300",@"name":@"건축·설비·인테리어"}
                        ,@{@"major":@"29999",@"depth":@"20400",@"name":@"화학·에너지·환경"}
                        ,@{@"major":@"29999",@"depth":@"20507",@"name":@"섬유·의류·패션"}
                        ,@{@"major":@"29999",@"depth":@"20600",@"name":@"의료·제약·바이오"}
                        ,@{@"major":@"29999",@"depth":@"20700",@"name":@"생활화학·화장품"}
                        ,@{@"major":@"29999",@"depth":@"20900",@"name":@"목재·제지·가구"}
                        ,@{@"major":@"29999",@"depth":@"20800",@"name":@"생활용품·소비재·기타"}
                        ,@{@"major":@"29999",@"depth":@"21000",@"name":@"식품가공·농축산·어업"}
                        ,@{@"major":@"39999",@"depth":@"30100",@"name":@"SI·SM·CRM·ERP"}
                        ,@{@"major":@"39999",@"depth":@"30200",@"name":@"웹에이전시"}
                        ,@{@"major":@"39999",@"depth":@"30300",@"name":@"소프트웨어·솔루션·ASP"}
                        ,@{@"major":@"39999",@"depth":@"30400",@"name":@"쇼핑몰·전자상거래·오픈마켓"}
                        ,@{@"major":@"39999",@"depth":@"30500",@"name":@"포털·컨텐츠·커뮤니티"}
                        ,@{@"major":@"39999",@"depth":@"30600",@"name":@"네트워크·통신서비스"}
                        ,@{@"major":@"39999",@"depth":@"30800",@"name":@"정보보안"}
                        ,@{@"major":@"39999",@"depth":@"30900",@"name":@"게임·애니메이션"}
                        ,@{@"major":@"39999",@"depth":@"31100",@"name":@"모바일·무선"}
                        ,@{@"major":@"39999",@"depth":@"31300",@"name":@"IT컨설팅"}
                        ,@{@"major":@"a9999",@"depth":@"a0103",@"name":@"방송·영상·프로덕션"}
                        ,@{@"major":@"a9999",@"depth":@"a0200",@"name":@"신문·잡지·인쇄·출판"}
                        ,@{@"major":@"a9999",@"depth":@"a0800",@"name":@"디자인·CAD"}
                        ,@{@"major":@"a9999",@"depth":@"a0304",@"name":@"광고·홍보·전시"}
                        ,@{@"major":@"a9999",@"depth":@"a0400",@"name":@"영화·음반·배급"}
                        ,@{@"major":@"a9999",@"depth":@"a0600",@"name":@"연예·엔터테인먼트"}
                        ,@{@"major":@"a9999",@"depth":@"a0700",@"name":@"문화·공연·예술"}
                        ,@{@"major":@"49999",@"depth":@"40100",@"name":@"기획·전략·경영"}
                        ,@{@"major":@"49999",@"depth":@"40200",@"name":@"사무·총무·법무"}
                        ,@{@"major":@"49999",@"depth":@"40250",@"name":@"인사·노무·교육"}
                        ,@{@"major":@"49999",@"depth":@"40305",@"name":@"경리·회계·결산"}
                        ,@{@"major":@"49999",@"depth":@"40306",@"name":@"재무·세무·IR"}
                        ,@{@"major":@"49999",@"depth":@"40600",@"name":@"비서·인포메이션"}
                        ,@{@"major":@"49999",@"depth":@"40700",@"name":@"사무보조·문서작성"}
                        ,@{@"major":@"59999",@"depth":@"50101",@"name":@"마케팅·광고"}
                        ,@{@"major":@"59999",@"depth":@"50700",@"name":@"상품기획·MD"}
                        ,@{@"major":@"59999",@"depth":@"50304",@"name":@"홍보·PR"}
                        ,@{@"major":@"59999",@"depth":@"50500",@"name":@"구매·자재"}
                        ,@{@"major":@"59999",@"depth":@"50210",@"name":@"유통·물류·재고"}
                        ,@{@"major":@"59999",@"depth":@"50400",@"name":@"무역·해외영업"}
                        ,@{@"major":@"59999",@"depth":@"50600",@"name":@"배송·운전·택배"}
                        ,@{@"major":@"b9999",@"depth":@"b0100",@"name":@"제품·서비스영업"}
                        ,@{@"major":@"b9999",@"depth":@"b0101",@"name":@"금융·보험영업"}
                        ,@{@"major":@"b9999",@"depth":@"b0110",@"name":@"기술영업"}
                        ,@{@"major":@"b9999",@"depth":@"b0104",@"name":@"광고영업"}
                        ,@{@"major":@"b9999",@"depth":@"b0130",@"name":@"법인영업"}
                        ,@{@"major":@"b9999",@"depth":@"b0120",@"name":@"영업관리·지원"}
                        ,@{@"major":@"b9999",@"depth":@"b0140",@"name":@"채권·심사"}
                        ,@{@"major":@"b9999",@"depth":@"b0200",@"name":@"판매·캐셔·매장관리"}
                        ,@{@"major":@"b9999",@"depth":@"b0500",@"name":@"부동산·창업"}
                        ,@{@"major":@"b9999",@"depth":@"b0300",@"name":@"이벤트·웨딩·나레이터"}
                        ,@{@"major":@"b9999",@"depth":@"b0400",@"name":@"단순홍보·회원관리"}
                        ,@{@"major":@"b9999",@"depth":@"b0410",@"name":@"교육상담·학원관리"}
                        ,@{@"major":@"b9999",@"depth":@"b0421",@"name":@"아웃바운드TM"}
                        ,@{@"major":@"b9999",@"depth":@"b0430",@"name":@"고객센터·인바운드·CS"}
                        ,@{@"major":@"38888",@"depth":@"35000",@"name":@"웹마스터"}
                        ,@{@"major":@"38888",@"depth":@"35100",@"name":@"네트워크·서버·보안·DBA"}
                        ,@{@"major":@"38888",@"depth":@"35200",@"name":@"웹기획·웹마케팅·PM"}
                        ,@{@"major":@"38888",@"depth":@"35400",@"name":@"웹디자인"}
                        ,@{@"major":@"38888",@"depth":@"35300",@"name":@"웹프로그래머"}
                        ,@{@"major":@"38888",@"depth":@"35310",@"name":@"응용프로그래머"}
                        ,@{@"major":@"38888",@"depth":@"35320",@"name":@"시스템프로그래머"}
                        ,@{@"major":@"38888",@"depth":@"35330",@"name":@"SE·시스템분석·설계"}
                        ,@{@"major":@"38888",@"depth":@"35900",@"name":@"IT·디자인·컴퓨터강사"}
                        ,@{@"major":@"38888",@"depth":@"35410",@"name":@"HTML코딩·컨텐츠관리"}
                        ,@{@"major":@"38888",@"depth":@"35500",@"name":@"웹사이트운영"}
                        ,@{@"major":@"d9999",@"depth":@"d0100",@"name":@"자동차·조선·기계"}
                        ,@{@"major":@"d9999",@"depth":@"d0200",@"name":@"반도체·디스플레이"}
                        ,@{@"major":@"d9999",@"depth":@"d0300",@"name":@"화학·에너지·환경·식품"}
                        ,@{@"major":@"d9999",@"depth":@"d0400",@"name":@"전기·전자·제어"}
                        ,@{@"major":@"d9999",@"depth":@"d0500",@"name":@"기계설계·CAD·CAM"}
                        ,@{@"major":@"d9999",@"depth":@"d0600",@"name":@"통신기술·네트워크구축"}
                        ,@{@"major":@"d9999",@"depth":@"d0700",@"name":@"건설·설계·인테리어"}
                        ,@{@"major":@"69999",@"depth":@"60506",@"name":@"시공·현장·공무"}
                        ,@{@"major":@"69999",@"depth":@"60100",@"name":@"생산관리·공정관리·품질관리"}
                        ,@{@"major":@"69999",@"depth":@"60300",@"name":@"생산·제조·설비·조립"}
                        ,@{@"major":@"69999",@"depth":@"60301",@"name":@"포장·가공·검사"}
                        ,@{@"major":@"69999",@"depth":@"60400",@"name":@"설치·정비·A/S"}
                        ,@{@"major":@"69999",@"depth":@"60800",@"name":@"시설·빌딩·안전"}
                        ,@{@"major":@"79999",@"depth":@"70100",@"name":@"경영분석·컨설턴트"}
                        ,@{@"major":@"79999",@"depth":@"70250",@"name":@"리서치·통계·사서"}
                        ,@{@"major":@"79999",@"depth":@"70500",@"name":@"외국어·번역·통역"}
                        ,@{@"major":@"79999",@"depth":@"71300",@"name":@"중고등 교사·강사"}
                        ,@{@"major":@"79999",@"depth":@"71310",@"name":@"초등·유치원·보육교사"}
                        ,@{@"major":@"79999",@"depth":@"71320",@"name":@"외국어·자격증·기술강사"}
                        ,@{@"major":@"79999",@"depth":@"71330",@"name":@"IT·디자인·컴퓨터강사"}
                        ,@{@"major":@"79999",@"depth":@"71902",@"name":@"학습지·방문교사"}
                        ,@{@"major":@"79999",@"depth":@"70600",@"name":@"법률·특허·상표"}
                        ,@{@"major":@"79999",@"depth":@"70705",@"name":@"회계·세무"}
                        ,@{@"major":@"79999",@"depth":@"73000",@"name":@"노무·헤드헌터·직업상담"}
                        ,@{@"major":@"79999",@"depth":@"70800",@"name":@"보안·경비·경호"}
                        ,@{@"major":@"79999",@"depth":@"71100",@"name":@"의사·약사·간호사"}
                        ,@{@"major":@"79999",@"depth":@"71407",@"name":@"미용·피부관리·스포츠"}
                        ,@{@"major":@"79999",@"depth":@"71508",@"name":@"요리·영양·제과제빵"}
                        ,@{@"major":@"79999",@"depth":@"72000",@"name":@"사회복지·요양보호·자원봉사"}
                        ,@{@"major":@"37777",@"depth":@"35420",@"name":@"그래픽디자인·CG"}
                        ,@{@"major":@"37777",@"depth":@"35430",@"name":@"출판·편집디자인"}
                        ,@{@"major":@"37777",@"depth":@"35440",@"name":@"제품·산업디자인"}
                        ,@{@"major":@"37777",@"depth":@"35474",@"name":@"광고·시각디자인"}
                        ,@{@"major":@"37777",@"depth":@"35480",@"name":@"건축·인테리어디자인"}
                        ,@{@"major":@"37777",@"depth":@"35490",@"name":@"의류·패션·잡화디자인"}
                        ,@{@"major":@"37777",@"depth":@"35450",@"name":@"캐릭터·애니메이션"}
                        ,@{@"major":@"c9999",@"depth":@"c0100",@"name":@"연출·제작·PD"}
                        ,@{@"major":@"c9999",@"depth":@"c0110",@"name":@"아나운서·리포터·성우"}
                        ,@{@"major":@"c9999",@"depth":@"c0200",@"name":@"영상·카메라·촬영"}
                        ,@{@"major":@"c9999",@"depth":@"c0300",@"name":@"기자"}
                        ,@{@"major":@"c9999",@"depth":@"c0400",@"name":@"작가·시나리오"}
                        ,@{@"major":@"c9999",@"depth":@"c0500",@"name":@"연예·매니저"}
                        ,@{@"major":@"c9999",@"depth":@"c0600",@"name":@"음악·음향"}
                        ,@{@"major":@"c9999",@"depth":@"c0704",@"name":@"광고제작·카피"}
                        ,@{@"major":@"c9999",@"depth":@"c0800",@"name":@"무대·스텝·오퍼레이터"}];
    
    self.AREA = @[@{@"area":@"0",@"name":@"전체"}
                  ,@{@"area":@"I000",@"name":@"서울특별시"}
                  ,@{@"area":@"E000",@"name":@"광주광역시"}
                  ,@{@"area":@"F000",@"name":@"대구광역시"}
                  ,@{@"area":@"G000",@"name":@"대전광역시"}
                  ,@{@"area":@"H000",@"name":@"부산광역시"}
                  ,@{@"area":@"J000",@"name":@"울산광역시"}
                  ,@{@"area":@"K000",@"name":@"인천광역시"}
                  ,@{@"area":@"B000",@"name":@"경기도"}
                  ,@{@"area":@"A000",@"name":@"강원도"}
                  ,@{@"area":@"C000",@"name":@"경상남도"}
                  ,@{@"area":@"D000",@"name":@"경상북도"}
                  ,@{@"area":@"L000",@"name":@"전라남도"}
                  ,@{@"area":@"M000",@"name":@"전라북도"}
                  ,@{@"area":@"O000",@"name":@"충청남도"}
                  ,@{@"area":@"P000",@"name":@"충청북도"}
                  ,@{@"area":@"N000",@"name":@"제주특별자치도"}
                  ,@{@"area":@"1000",@"name":@"개성공업지구"}
                  ,@{@"area":@"2000",@"name":@"금강산관광특구"}
                  ,@{@"area":@"Q000",@"name":@"전국"}
                  ,@{@"area":@"X000",@"name":@"중국·홍콩"}
                  ,@{@"area":@"Y000",@"name":@"미국"}
                  ,@{@"area":@"Z000",@"name":@"일본"}
                  ,@{@"area":@"R000",@"name":@"아시아·중동"}
                  ,@{@"area":@"S000",@"name":@"북아메리카"}
                  ,@{@"area":@"T000",@"name":@"남아메리카"}
                  ,@{@"area":@"U000",@"name":@"유럽"}
                  ,@{@"area":@"V000",@"name":@"오세아니아"}
                  ,@{@"area":@"W000",@"name":@"아프리카"}];
    
    self.SEX = @[@{@"sex":@"2",@"name":@"전체"}
                 ,@{@"sex":@"0",@"name":@"남자"}
                 ,@{@"sex":@"1",@"name":@"여자"}];
    
    self.PAY = @[@{@"pay":@"-1",@"name":@"전체"}
                 ,@{@"pay":@"0",@"name":@"회사내규에 따름"}
                 ,@{@"pay":@"1",@"name":@"1,000만원 이하"}
                 ,@{@"pay":@"2",@"name":@"1,000~1,400만원"}
                 ,@{@"pay":@"3",@"name":@"1,400~1,800만원"}
                 ,@{@"pay":@"4",@"name":@"1,800~2,200만원"}
                 ,@{@"pay":@"5",@"name":@"2,200~2,600만원"}
                 ,@{@"pay":@"6",@"name":@"2,600~3,000만원"}
                 ,@{@"pay":@"7",@"name":@"3,000~3,400만원"}
                 ,@{@"pay":@"8",@"name":@"3,400~3,800만원"}
                 ,@{@"pay":@"9",@"name":@"3,800~4,000만원"}
                 ,@{@"pay":@"10",@"name":@"4,000~5,000만원"}
                 ,@{@"pay":@"11",@"name":@"5,000~6,000만원"}
                 ,@{@"pay":@"12",@"name":@"6,000~7,000만원"}
                 ,@{@"pay":@"13",@"name":@"7,000~8,000만원"}
                 ,@{@"pay":@"14",@"name":@"8,000~9,000만원"}
                 ,@{@"pay":@"15",@"name":@"9,000~1억원"}
                 ,@{@"pay":@"16",@"name":@"1억원 이상"}];
    
    self.CTYPE = @[@{@"ctype":@"0",@"name":@"전체"}
                   ,@{@"ctype":@"1",@"name":@"중소기업(300명이하)"}
                   ,@{@"ctype":@"2",@"name":@"중견기업(300명이상)"}
                   ,@{@"ctype":@"3",@"name":@"대기업"}
                   ,@{@"ctype":@"4",@"name":@"대기업 계열사·자회사"}
                   ,@{@"ctype":@"5",@"name":@"벤처기업"}
                   ,@{@"ctype":@"6",@"name":@"외국계(외국 투자기업)"}
                   ,@{@"ctype":@"7",@"name":@"국내 공공기관·공기업"}
                   ,@{@"ctype":@"8",@"name":@"외국계(외국 법인기업)"}
                   ,@{@"ctype":@"9",@"name":@"국내 비영리단체·협회·교육제단"}
                   ,@{@"ctype":@"10",@"name":@"외국 기관·비영리기구·단체"}];

    self.MCAREERCHK = @[@{@"mcareerchk":@"0",@"name":@"전체"}
                 ,@{@"mcareerchk":@"1",@"name":@"신입"}
                 ,@{@"mcareerchk":@"2",@"name":@"경력"}];

    self.JTYPE = @[@{@"jtype":@"1111111",@"name":@"전체"}
                   ,@{@"jtype":@"1000000",@"name":@"정규직"}
                   ,@{@"jtype":@"0100000",@"name":@"계약직"}
                   ,@{@"jtype":@"0010000",@"name":@"계약직 후 정규직 전환 검토"}
                   ,@{@"jtype":@"0001000",@"name":@"병역특례"}
                   ,@{@"jtype":@"0000100",@"name":@"인턴직"}
                   ,@{@"jtype":@"0000010",@"name":@"인턴 후 정규직 전환 검토"}
                   ,@{@"jtype":@"0000001",@"name":@"위촉직"}];
    
    self.AREACODE = @{@"A000":@"강원도 전지역" ,@"A010":@"강릉시" ,@"A020":@"고성군" ,@"A030":@"동해시" ,@"A040":@"삼척시" ,@"A050":@"속초시" ,@"A060":@"양구군" ,@"A070":@"양양군" ,@"A080":@"영월군" ,@"A090":@"원주시" ,@"A100":@"인제군" ,@"A110":@"정성군" ,@"A120":@"철원군" ,@"A130":@"춘천시" ,@"A140":@"태백시" ,@"A150":@"평창군" ,@"A160":@"홍천군" ,@"A170":@"화천군" ,@"A180":@"횡성군" ,@"B000":@"경기도 전지역" ,@"B010":@"가평군" ,@"B020":@"고양시 덕양" ,@"B030":@"고양시 일산" ,@"B031":@"고양시 일산" ,@"B040":@"과천시" ,@"B050":@"광명시" ,@"B060":@"광주시" ,@"B070":@"구리시" ,@"B080":@"군포시" ,@"B090":@"김포시" ,@"B100":@"남양주시" ,@"B110":@"동두천시" ,@"B120":@"부천시 소사" ,@"B130":@"부천시 오정" ,@"B140":@"부천시 원미" ,@"B150":@"성남시 분당" ,@"B160":@"성남시 수정" ,@"B170":@"성남시 중원" ,@"B180":@"수원시 권선" ,@"B190":@"수언시 장안" ,@"B200":@"수원시 팔달" ,@"B201":@"수원시 영통" ,@"B210":@"시흥시" ,@"B220":@"안산시 단원" ,@"B221":@"안산시 상록" ,@"B230":@"안성시" ,@"B240":@"안양시 동안" ,@"B250":@"안양시 만안" ,@"B260":@"양주시" ,@"B270":@"양평군" ,@"B280":@"여주군" ,@"B290":@"연천군" ,@"B300":@"오산시" ,@"B310":@"용인시 기흥" ,@"B311":@"용인시 수지" ,@"B312":@"용인시 처인" ,@"B320":@"의왕시" ,@"B330":@"의정부시" ,@"B340":@"이천시" ,@"B350":@"파주시" ,@"B360":@"평택시" ,@"B370":@"포천시" ,@"B380":@"하남시" ,@"B390":@"화성시" ,@"C000":@"경상남도 전지역" ,@"C010":@"거제시" ,@"C020":@"거창군" ,@"C030":@"고성군" ,@"C040":@"김해시" ,@"C050":@"남해군" ,@"C060":@"마산시" ,@"C080":@"밀양시" ,@"C090":@"사천시" ,@"C100":@"산청군" ,@"C110":@"양산시" ,@"C120":@"의령군" ,@"C130":@"진주시" ,@"C140":@"진해시" ,@"C150":@"창녕군" ,@"C160":@"창원시" ,@"C170":@"통영시" ,@"C180":@"하동군" ,@"C190":@"함안군" ,@"C200":@"함양군" ,@"C210":@"합천군" ,@"D000":@"경상북도 전지역" ,@"D010":@"경산시" ,@"D020":@"경주시" ,@"D030":@"고령군" ,@"D040":@"구미시" ,@"D050":@"군위군" ,@"D060":@"김천시" ,@"D070":@"문경시" ,@"D080":@"봉화군" ,@"D090":@"상주시" ,@"D100":@"성주군" ,@"D110":@"안동시" ,@"D120":@"영덕군" ,@"D130":@"영양군" ,@"D140":@"영주시" ,@"D150":@"영천시" ,@"D160":@"예천군" ,@"D170":@"울릉군" ,@"D180":@"울진군" ,@"D190":@"의성군" ,@"D200":@"청도군" ,@"D210":@"청송군" ,@"D220":@"칠곡군" ,@"D230":@"포항시 남구" ,@"D240":@"포항시 북구" ,@"E000":@"광주광역시" ,@"E010":@"광산구" ,@"E020":@"남구" ,@"E030":@"동구" ,@"E040":@"북구" ,@"E050":@"서구" ,@"F000":@"대구광역시" ,@"F010":@"남구" ,@"F020":@"달서구" ,@"F030":@"달성군" ,@"F040":@"동구" ,@"F050":@"북구" ,@"F060":@"서구" ,@"F070":@"수성구" ,@"F080":@"중구" ,@"G000":@"대전광역시" ,@"G010":@"대덕구" ,@"G020":@"동구" ,@"G030":@"서구" ,@"G040":@"유성구" ,@"G050":@"중구" ,@"H000":@"부산광역시" ,@"H010":@"강서구" ,@"H020":@"금정구" ,@"H030":@"기장군" ,@"H040":@"남구" ,@"H050":@"동구" ,@"H060":@"동래구" ,@"H070":@"부산진구" ,@"H080":@"북구" ,@"H090":@"사상구" ,@"H100":@"사하구" ,@"H110":@"서구" ,@"H120":@"수영구" ,@"H130":@"연제구" ,@"H140":@"영도구" ,@"H150":@"중구" ,@"H160":@"해운대구" ,@"I000":@"서울특별시" ,@"I010":@"강남구" ,@"I020":@"강동구" ,@"I030":@"강북구" ,@"I040":@"강서구" ,@"I050":@"관악구" ,@"I060":@"광진구" ,@"I070":@"구로구" ,@"I080":@"금천구" ,@"I090":@"노원구" ,@"I100":@"도봉구" ,@"I110":@"동대문구" ,@"I120":@"동작구" ,@"I130":@"마포구" ,@"I140":@"서대문구" ,@"I150":@"서초구" ,@"I160":@"성동구" ,@"I170":@"성북구" ,@"I180":@"송파구" ,@"I190":@"양천구" ,@"I200":@"영등포구" ,@"I210":@"용산구" ,@"I220":@"은평구" ,@"I230":@"종로구" ,@"I240":@"중구" ,@"I250":@"중랑구" ,@"J000":@"울산광역시" ,@"J010":@"남구" ,@"J020":@"동구" ,@"J030":@"북구" ,@"J040":@"울주군" ,@"J050":@"중구" ,@"K000":@"인천광역시" ,@"K010":@"강화군" ,@"K020":@"계양구" ,@"K030":@"남구" ,@"K040":@"남동구" ,@"K050":@"동구" ,@"K060":@"부평구" ,@"K070":@"서구" ,@"K080":@"연수구" ,@"K090":@"웅진군" ,@"K100":@"중구" ,@"L000":@"전라남도 전지역" ,@"L010":@"강진군" ,@"L020":@"고흥군" ,@"L030":@"곡성군" ,@"L040":@"광양시" ,@"L050":@"구례군" ,@"L060":@"나주시" ,@"L070":@"담양군" ,@"L080":@"목포시" ,@"L090":@"무안군" ,@"L100":@"보성군" ,@"L110":@"순천시" ,@"L120":@"시안군" ,@"L130":@"여수시" ,@"L140":@"영광군" ,@"L150":@"영암군" ,@"L160":@"완도군" ,@"L170":@"장성군" ,@"L180":@"장흥군" ,@"L190":@"진도군" ,@"L200":@"함평군" ,@"L210":@"해남군" ,@"L220":@"화순군" ,@"M000":@"전라북도 전지역" ,@"M010":@"고창군" ,@"M020":@"군산시" ,@"M030":@"김제시" ,@"M040":@"남원시" ,@"M050":@"무주군" ,@"M060":@"부안군" ,@"M070":@"순창군" ,@"M080":@"완주군" ,@"M090":@"익산시" ,@"M100":@"임실군" ,@"M110":@"장수군" ,@"M120":@"전주시 덕진" ,@"M130":@"전주시 완산" ,@"M140":@"정읍시" ,@"M150":@"진안군" ,@"N000":@"제주도 전지역" ,@"N030":@"서귀포시" ,@"N040":@"제주시" ,@"O000":@"충청남도 전지역" ,@"O160":@"계룡시" ,@"O010":@"공주시" ,@"O020":@"금산군" ,@"O030":@"논산시" ,@"O040":@"당진군" ,@"O050":@"보령시" ,@"O060":@"부여군" ,@"O070":@"서산시" ,@"O080":@"서천군" ,@"O090":@"아산시" ,@"O100":@"연기군" ,@"O110":@"예산군" ,@"O120":@"천안시" ,@"O130":@"청양군" ,@"O140":@"태안군" ,@"O150":@"홍성군" ,@"P000":@"충청북도 전지역" ,@"P010":@"괴산군" ,@"P020":@"단양군" ,@"P030":@"보은군" ,@"P040":@"영동군" ,@"P050":@"옥천군" ,@"P060":@"음성군" ,@"P070":@"제천시" ,@"P080":@"진천군" ,@"P090":@"청원군" ,@"P100":@"청주시 상당" ,@"P110":@"청주시 흥덕" ,@"P120":@"충주시" ,@"P130":@"증평군" ,@"R360":@"그루지아" ,@"R160":@"네팔" ,@"R010":@"대만" ,@"R170":@"동티모르" ,@"R180":@"라오스" ,@"R190":@"레바논" ,@"R020":@"말레이시아" ,@"R200":@"몰디브" ,@"R030":@"몽골" ,@"R040":@"미얀마" ,@"R210":@"바레인" ,@"R050":@"방글라데시" ,@"R060":@"베트남" ,@"R220":@"부탄" ,@"R230":@"브루나이" ,@"R070":@"사우디아라비아" ,@"R080":@"스리랑카" ,@"R240":@"시리아" ,@"R090":@"싱가포르" ,@"R250":@"아랍에미리트" ,@"R260":@"아프가니스탄" ,@"R270":@"예멘" ,@"R280":@"오만" ,@"R290":@"요르단" ,@"R370":@"우즈베키스탄" ,@"R300":@"이라크" ,@"R310":@"이란" ,@"R320":@"이스라엘" ,@"R100":@"인도" ,@"R110":@"인도네시아" ,@"R380":@"카자흐스탄" ,@"R330":@"카타르" ,@"R120":@"캄보디아" ,@"R340":@"쿠웨이트" ,@"R390":@"키르기즈스탄" ,@"R400":@"타지키스탄" ,@"R130":@"태국" ,@"R410":@"투르크메니스" ,@"R350":@"파키스탄" ,@"R140":@"필리핀" ,@"R150":@"기타" ,@"R000":@"아시아 전지역" ,@"S020":@"캐나다" ,@"S010":@"멕시코" ,@"S040":@"그레나다" ,@"S050":@"그린란드" ,@"S060":@"도미니카공화국" ,@"S070":@"바베이도스" ,@"S080":@"바하마" ,@"S090":@"세인트루시아" ,@"S100":@"세인트빈센트" ,@"S110":@"세인트키츠네" ,@"S120":@"코스타리카" ,@"S130":@"푸에르토리코" ,@"S030":@"기타" ,@"S000":@"북미 전지역" ,@"T140":@"가이아나" ,@"T010":@"과테말라" ,@"T150":@"니카라과" ,@"T160":@"도미니카연방" ,@"T020":@"베네수엘라" ,@"T170":@"벨리즈" ,@"T180":@"볼리비아" ,@"T030":@"브라질" ,@"T190":@"수리남" ,@"T040":@"아르헨티나" ,@"T200":@"아이티" ,@"T210":@"앤티가바부다" ,@"T050":@"에콰도르" ,@"T220":@"엘살바도르" ,@"T060":@"온두라스" ,@"T070":@"우루과이" ,@"T230":@"자메이카" ,@"T080":@"칠레" ,@"T090":@"콜롬비아" ,@"T100":@"쿠바" ,@"T240":@"트리니다드토" ,@"T110":@"파나마" ,@"T250":@"파라과이" ,@"T120":@"페루" ,@"T130":@"기타" ,@"T000":@"중남미 전지역" ,@"U010":@"그리스" ,@"U020":@"네덜란드" ,@"U030":@"노르웨이" ,@"U040":@"덴마크" ,@"U050":@"독일" ,@"U220":@"라트비아" ,@"U060":@"러시아" ,@"U230":@"루마니아" ,@"U240":@"룩셈부르크" ,@"U250":@"리투아니아" ,@"U260":@"리히텐슈타인" ,@"U270":@"마케도니아" ,@"U280":@"모나코" ,@"U290":@"몰도바" ,@"U300":@"몰타" ,@"U310":@"바티칸시국" ,@"U070":@"벨기에" ,@"U320":@"벨라루스" ,@"U330":@"보스니아헤르" ,@"U340":@"불가리아" ,@"U350":@"사이프러스" ,@"U360":@"산마리노" ,@"U370":@"세르비아몬테" ,@"U080":@"스웨덴" ,@"U090":@"스위스" ,@"U100":@"스페인" ,@"U380":@"슬로바키아" ,@"U390":@"슬로베니아" ,@"U400":@"아르메니아" ,@"U410":@"아이슬란드" ,@"U420":@"아일랜드" ,@"U430":@"아제르바이잔" ,@"U440":@"안도라" ,@"U450":@"알바니아" ,@"U460":@"에스토니아" ,@"U110":@"영국" ,@"U470":@"오스트리아" ,@"U490":@"우크라이나" ,@"U120":@"이탈리아" ,@"U130":@"체코" ,@"U510":@"크로아티아" ,@"U140":@"터키" ,@"U150":@"포르투갈" ,@"U160":@"폴란드" ,@"U170":@"프랑스" ,@"U180":@"핀란드" ,@"U190":@"헝가리" ,@"U200":@"기타" ,@"U000":@"유럽 전지역" ,@"V050":@"호주" ,@"V010":@"괌" ,@"V020":@"뉴질랜드" ,@"V070":@"나우루공화국" ,@"V080":@"마셜" ,@"V090":@"미크로네이사" ,@"V100":@"바누아투" ,@"V110":@"사모아" ,@"V120":@"솔로몬제도" ,@"V130":@"키리바시" ,@"V140":@"통가" ,@"V150":@"투발루" ,@"V030":@"파푸아뉴기니" ,@"V160":@"팔라우" ,@"V040":@"피지" ,@"V060":@"기타" ,@"V000":@"오세아니아" ,@"W010":@"가나" ,@"W020":@"가봉" ,@"W160":@"감비아" ,@"W170":@"기니" ,@"W180":@"기니비사우" ,@"W190":@"나미비아" ,@"W030":@"나이지리아" ,@"W040":@"남아프리카공화국" ,@"W200":@"니제르" ,@"W210":@"라이베리아" ,@"W220":@"레소토" ,@"W230":@"르완다" ,@"W050":@"라비아" ,@"W240":@"마다가스카르" ,@"W250":@"말라위" ,@"W260":@"말리" ,@"W060":@"모로코" ,@"W270":@"모리셔스" ,@"W280":@"모리타니아" ,@"W290":@"모잠비크" ,@"W300":@"베냉" ,@"W310":@"보츠와나" ,@"W320":@"부룬디" ,@"W330":@"부르키나파소" ,@"W340":@"상투메프린시" ,@"W350":@"세네갈" ,@"W360":@"세이셀" ,@"W370":@"소말리아" ,@"W070":@"수단" ,@"W380":@"스와질란드" ,@"W390":@"시에라리온" ,@"W080":@"알제리" ,@"W400":@"앙골라" ,@"W410":@"에리트레아" ,@"W090":@"에티오피아" ,@"W100":@"우간다" ,@"W110":@"이집트" ,@"W420":@"잠비아" ,@"W430":@"적도가니" ,@"W440":@"중앙아프리카" ,@"W450":@"지부티" ,@"W460":@"잠바브웨" ,@"W470":@"차드" ,@"W480":@"카메룬" ,@"W490":@"카보베르데" ,@"W120":@"케냐" ,@"W500":@"코모로" ,@"W510":@"코트디부아르" ,@"W520":@"콩고" ,@"W530":@"콩고민주공화국" ,@"W130":@"탄자니아" ,@"W540":@"토고" ,@"W140":@"튀니지" ,@"W150":@"기타" ,@"W000":@"아프리카 전지역" ,@"X010":@"북경" ,@"X020":@"천진" ,@"X030":@"상해" ,@"X040":@"중경" ,@"X050":@"홍콩" ,@"X060":@"마카오" ,@"X070":@"감숙성" ,@"X080":@"강서성" ,@"X090":@"강소성" ,@"X100":@"광동성" ,@"X110":@"귀주성" ,@"X120":@"길림성" ,@"X130":@"복건성" ,@"X140":@"사천성" ,@"X150":@"산동성" ,@"X160":@"산서성" ,@"X170":@"섬서성" ,@"X180":@"안휘성" ,@"X190":@"요녕성" ,@"X200":@"운남성" ,@"X210":@"절강성" ,@"X220":@"청해성" ,@"X230":@"하남성" ,@"X240":@"하북성" ,@"X250":@"해남성" ,@"X260":@"호남성" ,@"X270":@"호북성" ,@"X280":@"흑룡강성" ,@"X290":@"기타" ,@"X000":@"중국·홍콩" ,@"Y010":@"보스턴" ,@"Y020":@"필라델피아" ,@"Y030":@"뉴욕" ,@"Y040":@"시카고" ,@"Y050":@"로스앤젤레스" ,@"Y060":@"워싱턴 D.C" ,@"Y070":@"네바다주" ,@"Y080":@"네브라스카주" ,@"Y090":@"노스다코타주" ,@"Y100":@"노스케롤라이" ,@"Y110":@"뉴멕시코주" ,@"Y120":@"뉴욕주" ,@"Y130":@"뉴저지주" ,@"Y140":@"뉴햄프셔주" ,@"Y150":@"델라웨어주" ,@"Y160":@"로드아일랜드" ,@"Y170":@"루지애나주" ,@"Y180":@"메릴랜드주" ,@"Y190":@"메사추세츠주" ,@"Y200":@"메인주" ,@"Y210":@"몬타나주" ,@"Y220":@"미네소타주" ,@"Y230":@"미시건주" ,@"Y240":@"미시시피주" ,@"Y250":@"미주리주" ,@"Y260":@"버먼트주" ,@"Y270":@"버지니아주" ,@"Y280":@"웨스트버지니" ,@"Y290":@"사우스다코타" ,@"Y300":@"사우스캐롤라" ,@"Y310":@"아이다호주" ,@"Y320":@"아이오와주" ,@"Y330":@"알래스카주" ,@"Y340":@"알칸사주" ,@"Y350":@"애리조나주" ,@"Y360":@"앨라배마주" ,@"Y370":@"오레건주" ,@"Y380":@"오클라호마주" ,@"Y390":@"오하이오주" ,@"Y400":@"와이오밍주" ,@"Y410":@"워싱턴주" ,@"Y420":@"위스콘신주" ,@"Y430":@"유타주" ,@"Y440":@"인디애나주" ,@"Y450":@"일리노이주" ,@"Y460":@"조지아주" ,@"Y470":@"캔사스주" ,@"Y480":@"캘리포니아주" ,@"Y490":@"켄터키주" ,@"Y500":@"코네티컷주" ,@"Y510":@"콜로라도주" ,@"Y520":@"테네시주" ,@"Y530":@"텍사스주" ,@"Y540":@"펜실베니아주" ,@"Y550":@"플로리다주" ,@"Y560":@"하와이주" ,@"Y000":@"미국 전지역" ,@"Z010":@"도쿄" ,@"Z020":@"오오사카" ,@"Z030":@"쿄토" ,@"Z040":@"가가와" ,@"Z050":@"가고시마" ,@"Z060":@"가나가와" ,@"Z070":@"고오찌" ,@"Z080":@"구마모또" ,@"Z090":@"군마" ,@"Z100":@"기후" ,@"Z110":@"나가노" ,@"Z120":@"나가사끼" ,@"Z130":@"나라" ,@"Z140":@"나이가따" ,@"Z150":@"도꾸시마" ,@"Z160":@"도야마" ,@"Z170":@"도찌끼" ,@"Z180":@"돗도리" ,@"Z190":@"미야끼" ,@"Z200":@"미야자끼" ,@"Z210":@"미에" ,@"Z220":@"사가" ,@"Z230":@"사이따마" ,@"Z240":@"시가" ,@"Z250":@"시마네" ,@"Z260":@"시즈오까" ,@"Z270":@"아끼따" ,@"Z280":@"아오모리" ,@"Z290":@"아이지" ,@"Z300":@"야마까따" ,@"Z310":@"야마구찌" ,@"Z320":@"야마나시" ,@"Z330":@"에히메" ,@"Z340":@"오끼야마" ,@"Z350":@"오끼나와" ,@"Z360":@"오오이따" ,@"Z370":@"와까야마" ,@"Z380":@"이바라끼" ,@"Z390":@"이시까와" ,@"Z400":@"이와떼" ,@"Z410":@"지바" ,@"Z420":@"훗카이도" ,@"Z430":@"효고" ,@"Z440":@"후꾸시마" ,@"Z450":@"후꾸오까" ,@"Z460":@"후꾸이" ,@"Z470":@"히로시마" ,@"Z000":@"일본 전지역"};
    
    return self;
}

-(void) jobkoreaRequest:(NSString*)url handler:(void (^)(NSArray*))aHandlerBlock
{
    
    self.handlerBlock = aHandlerBlock;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        XMLParser.delegate = self;
        [XMLParser parse];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
        NSLog(@"%@", error);
    }];
    
    
    [operation start];
}

#pragma mark - Parsing lifecycle

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    [self.xmlValue setString:@""];
    [self.items removeAllObjects];
}

- (void)startTheParsingProcess:(NSData *)parserData
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:parserData]; //parserData passed to NSXMLParser delegate which starts the parsing process
    
    [parser setDelegate:self];
    [parser parse]; // starts the event-driven parsing operation.
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"Items"]) {
        elementType = etItem;
    }
	
	[self.xmlValue setString:@""];
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
	if (elementType != etItem)
		return;
	
    if ([elementName isEqualToString:@"Items"]) {
        [self.items addObject:[NSDictionary dictionaryWithDictionary:self.item]];
        elementType = etNone;
    }else {
        if ([elementName isEqualToString:@"GI_Part_No"]) {
            NSArray *array = [self.xmlValue componentsSeparatedByString:@","];
            [self.xmlValue setString:@""];
            for (int i = 0; i < [array count]; i++) {
                int j = 0;
                for (; j < [self.GI_Part_No count]; j++) {
                    if ([[[self.GI_Part_No objectAtIndex:j] objectForKey:@"depth"] isEqualToString:[array objectAtIndex:i]]) {
                        [self.xmlValue appendString:[[self.GI_Part_No objectAtIndex:j] objectForKey:@"name"]];
                        break;
                    }
                }
                if (j < [self.GI_Part_No count]) {
                    [self.xmlValue appendString:[array objectAtIndex:i]];
                }
                if (i < [array count] - 1) {
                    [self.xmlValue appendString:@","];
                }
            }
        }
        [self.item setObject:[NSString stringWithString:self.xmlValue] forKey:elementName];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (elementType == etItem) {
		[self.xmlValue appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"parserDidEndDocument");
    self.handlerBlock(self.items);
}

-(void) GIBRequest:(NSDictionary*)GIB handler:(void (^)(NSDictionary*))aGIBBlock
{
    http://m.jobkorea.co.kr/List_GI/GIB_Read.asp?GI_No=%@&C_ID=%@&Show_Stat=&TS_GIB_Div=4&Tab_Stat=3
    self.GIBBlock = aGIBBlock;
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://m.jobkorea.co.kr"]];
    NSMutableURLRequest *theRequest = [httpClient requestWithMethod:@"GET" path:@"/List_GI/GIB_Read.asp" parameters:@{@"GI_No":[GIB objectForKey:@"GI_No"], @"C_ID":[GIB objectForKey:@"C_ID"], @"Show_Stat":@"", @"TS_GIB_Div":@"4", @"Tab_Stat":@"3"}];
    [theRequest setTimeoutInterval:20.0f];
    [theRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    [theRequest setValue:@"Mozilla/5.0 (iPod; U; CPU iPhone OS 3_1_3 like Mac OS X; ko-kr) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7E18 Safari/528.16" forHTTPHeaderField:@"User-Agent"];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:theRequest];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", [operation responseString]);
        [self GIBParse:[operation responseString]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [operation start];
}

-(void) GIBParse:(NSString*)GIB handler:(void (^)(NSDictionary*))aGIBBlock
{
    self.GIBBlock = aGIBBlock;
    [self GIBParse:GIB];
}

-(void) GIBParse:(NSString*)GIB
{
    NSMutableDictionary *gib = [[NSMutableDictionary alloc] init];
    
    NSRange range = [GIB rangeOfString:@"http://joburl.kr/"];
    
//    NSLog(@"%@", GIB);
    NSString *temp;
    if (range.length > 0) {
        temp = [GIB substringFromIndex:range.location];
        range = [temp rangeOfString:@" "];
        temp = [temp substringToIndex:range.location];
        
        [gib setObject:[NSString stringWithString:temp] forKey:@"joburl"];
    }
    
    range = [GIB rangeOfString:@"\"&C_ID="];
    if (range.length > 0) {
        temp = [GIB substringFromIndex:range.location + range.length];
        range = [temp rangeOfString:@"&"];
        temp = [temp substringToIndex:range.location];
        [gib setObject:[NSString stringWithString:temp] forKey:@"C_ID"];
    }
    
    range = [GIB rangeOfString:@"<th>주소</th>"];
    if (range.length > 0) {
        temp = [GIB substringFromIndex:range.location + range.length];
		range = [temp rangeOfString:@"<td>"];
        temp = [temp substringFromIndex:range.location + range.length];
        range = [temp rangeOfString:@"<br>"];
        temp = [temp substringToIndex:range.location];
        [gib setObject:[NSString stringWithString:temp] forKey:@"address"];
    }
	
    if (self.GIBBlock) {
        self.GIBBlock(gib);
    }
}

-(void) GIBWebParse:(NSDictionary*)GIB handler:(void (^)(NSDictionary*))GIBWebBlock
{
    self.GIBWebBlock = GIBWebBlock;
    [self.webStr removeAllObjects];
    [self.GIBWebView stopLoading];
    [self.webView1 stopLoading];
    [self.webView2 stopLoading];
    [self.webView3 stopLoading];
    [self.webView4 stopLoading];
    webLoadCount = 0;
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.jobkorea.co.kr/List_GI/GIB_Read.asp?GI_No=%@&C_ID=%@&Show_Stat=&TS_GIB_Div=4&Tab_Stat=3", [GIB objectForKey:@"GI_No"], [GIB objectForKey:@"C_ID"]]]];
    [theRequest setTimeoutInterval:20.0f];
    [theRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    [theRequest setValue:@"Mozilla/5.0 (iPod; U; CPU iPhone OS 3_1_3 like Mac OS X; ko-kr) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7E18 Safari/528.16" forHTTPHeaderField:@"User-Agent"];
    
	[self.GIBWebView loadRequest:theRequest];
    
    [self.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.jobkorea.co.kr/List_GI/GIB_Read.asp?GI_No=%@", [GIB objectForKey:@"GI_No"]]]]];
    
    [self.webView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.jobkorea.co.kr/List_GI/GIB_Read_Detail.asp?GI_No=%@&C_ID=%@", [GIB objectForKey:@"GI_No"], [GIB objectForKey:@"C_ID"]]]]];
    
    [self.webView3 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.jobkorea.co.kr/List_GI/GIB_Read.asp?GI_No=%@&C_ID=%@&TS_GIB_Div=4&Tab_Stat=1", [GIB objectForKey:@"GI_No"], [GIB objectForKey:@"C_ID"]]]]];
    
    [self.webView4 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.jobkorea.co.kr/List_GI/GIB_Read.asp?GI_No=%@&C_ID=%@&TS_GIB_Div=4&Tab_Stat=2", [GIB objectForKey:@"GI_No"], [GIB objectForKey:@"C_ID"]]]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    if ([webView isEqual:self.GIBWebView]) {
        [self GIBParse:html handler:^(NSDictionary *GIB) {
            NSLog(@"%@", GIB);
            if ([[GIB objectForKey:@"C_ID"] length] > 0) {
                [self.GIBWebView stopLoading];

                NSLog(@"%@", GIB);
                NSLog(@"%@",  [GIB objectForKey:@"address"]);
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", [[GIB objectForKey:@"address"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                NSLog(@"%@", url);
                NSLog(@"%@", [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", [[GIB objectForKey:@"address"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]);
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    NSLog(@"App.net Global Stream: %@", JSON);
					if ([[JSON objectForKey:@"results"] count] > 0) {
						[GIB setValue:[[[[[JSON objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] forKey:@"lat"];
						[GIB setValue:[[[[[JSON objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] forKey:@"lng"];
						NSLog(@"%@", [[[[JSON objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"]);
						
						[self.webStr setValue:[GIB objectForKey:@"lng"] forKey:@"lng"];
						[self.webStr setValue:[GIB objectForKey:@"lat"] forKey:@"lat"];
					}
                    
                    webLoadCount++;
                    [self jobWebViewLoad];
                    
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    NSLog(@"%@", error);
                }];
                [operation start];
                
            }
        }];
    }else if ([self.webView1 isEqual:webView]) {
        NSRange range = [html rangeOfString:@"<h3 class=\"hS3\">주요정보</h3>"];
        //        NSLog(@"%@", html);
        //    NSLog(@"%@", GIB);
        NSString *temp;
        if (range.length > 0) {
            [self.webView1 stopLoading];
            temp = [html substringFromIndex:range.location];
            range = [temp rangeOfString:@"<p class=\"boxLinkMore"];
            [self.webStr setValue:[NSString stringWithString:[temp substringToIndex:range.location]] forKey:@"string1"];
            temp = [temp substringFromIndex:range.location];
            range = [temp rangeOfString:@"<h3 class=\"hS3\">우대사항</h3>"];
            if (range.length > 0) {
                temp = [temp substringFromIndex:range.location];
                range = [temp rangeOfString:@"</div>"];
                [self.webStr setValue:[NSString stringWithString:[temp substringToIndex:range.location + range.length]] forKey:@"string2"];
            }else {
                [self.webStr setValue:@"" forKey:@"string2"];
            }
        }
        webLoadCount++;
        [self jobWebViewLoad];
    }else if ([self.webView2 isEqual:webView]) {
        NSRange range = [html rangeOfString:@"<div class=\"coDetail\""];
        
        //    NSLog(@"%@", GIB);
        NSString *temp;
        if (range.length > 0) {
            [self.webView2 stopLoading];
           temp = [html substringFromIndex:range.location];
            range = [temp rangeOfString:@"<p class=\"actGIB2\">"];
            [self.webStr setValue:[NSString stringWithString:[temp substringToIndex:range.location]] forKey:@"string4"];
        }
        webLoadCount++;
        [self jobWebViewLoad];
    }else if ([self.webView3 isEqual:webView]) {
        NSRange range = [html rangeOfString:@"<h3 class=\"hS3\">복리후생</h3>"];
        
        //    NSLog(@"%@", GIB);
        NSString *temp;
        if (range.length > 0) {
            [self.webView3 stopLoading];
            temp = [html substringFromIndex:range.location];
            range = [temp rangeOfString:@"<p class=\"boxLinkMore\">"];
            [self.webStr setValue:[NSString stringWithString:[temp substringToIndex:range.location]] forKey:@"string3"];
        }
        webLoadCount++;
        [self jobWebViewLoad];
    }else if ([self.webView4 isEqual:webView]) {
        NSRange range = [html rangeOfString:@"<h3 class=\"hS3\">담당자 정보</h3>"];
        
        //    NSLog(@"%@", GIB);
        NSString *temp;
        if (range.length > 0) {
            [self.webView4 stopLoading];
            temp = [html substringFromIndex:range.location];
            range = [temp rangeOfString:@"<p class=\"boxLinkMore\">"];
            [self.webStr setValue:[NSString stringWithString:[temp substringToIndex:range.location]] forKey:@"string5"];
        }
        webLoadCount++;
        [self jobWebViewLoad];
    }
}

-(void) jobWebViewLoad
{
    if (webLoadCount > 4) {
        self.GIBWebBlock(self.webStr);
    }
}

@end
