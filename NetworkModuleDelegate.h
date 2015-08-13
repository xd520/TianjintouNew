
enum kPostStatus{
    kPostStatusNone=0,
    kPostStatusBeging=1,
    kPostStatusEnded=2,
    kPostStatusError=3,
    kPostStatusReceiving=4
};
typedef enum kPostStatus kPostStatus;

enum kBusinessTag
{
	kBusinessTagUserGetList = 0,
    kBusinessTagGetZXZX = 1,
    kBusinessTagUserGetListAgain = 2,
    kBusinessTagGetZXZXAgain = 3,
    kBusinessTagGetFundslistAgain = 4,
    kBusinessTagUserLogin = 5,
    kBusinessTagGetMyfunds = 6,
    kBusinessTagGetFundslist = 7,
    kBusinessTagGetUpdateUserName = 8,
    kBusinessTagGetMyinv = 9,
    kBusinessTagGetCancelWt = 10,
    kBusinessTagGetconfirmJK = 11,
    kBusinessTagGetMyprj = 12,
    kBusinessTagUpdateImage = 13,
    kBusinessTagGetMyprjAgain = 14,
    kBusinessTagGetLogOut = 15,
    kBusinessTagGetBankBD = 16,
    kBusinessTagGetBankRJ = 17,
    kBusinessTagGetBankCJ = 18,
    kBusinessTagGetBankCJAgain = 19,
    kBusinessTagGetBanner = 20,
    kBusinessTagGetIndustry = 21,
    kBusinessTagGetProvince = 22,
    kBusinessTagGetStatus = 23,
    kBusinessTagGetCity = 24,
    kBusinessTagGetWYTZ = 25,
    kBusinessTagGetBankInfo = 26,
    kBusinessTagGetProjectDetail = 27,
    kBusinessTagGetRZF = 28,
    kBusinessTagGetRegisterTZF = 29,
    kBusinessTagGetRegisterUpfile = 30,
    kBusinessTagGetYzmobile = 31,
    kBusinessTagGetYzzjbh = 32,
    kBusinessTagGetYzm = 33,
    kBusinessTagGetYCheckyzm = 34,
    kBusinessTagGetIwLeader = 35,
    kBusinessTagGetIwFlollow = 36,
    kBusinessTagGetCheckIos = 37,
    kBusinessTagGetRegisterUpfileAgin1 = 38,
    kBusinessTagGetRegisterUpfileAgin2 = 39,
    kBusinessTagGetSjTzr = 40,
    kBusinessTagGetLtrSq = 41,
    kBusinessTagGetLtrForm = 42,
    kBusinessTagGetBankIntoGoldCJ = 43,
    kBusinessTagUserGetEndRefreshList = 44,
    kBusinessTagGetYzmobileAgain = 45,
    kBusinessTagGetYzzjbhAgain = 46,
    kBusinessTagGetUpdateUserNameAgain = 47,
    kBusinessTagGetJRLogin = 49,
    kBusinessTagGetModifyTzr = 48,
    kBusinessTagGetJRLogout = 50,
    kBusinessTagGetJRCaptcha = 51,
    kBusinessTagGetJRValidateUsername = 52,
    kBusinessTagGetJRValidateMobilePhone = 53,
    kBusinessTagGetJRSendVcode = 54,
    kBusinessTagGetJRCheckVcode = 55,
    kBusinessTagGetJRMyzc = 56,
    kBusinessTagGetJRLogininfo = 57,
    kBusinessTagGetJRMyBankcard = 58,
    kBusinessTagGetJRFundsList = 59,
    kBusinessTagGetJRtransRecordList = 60,
    kBusinessTagGetJRProductCenter = 61,
    kBusinessTagGetJRloadData = 61,
    kBusinessTagGetJRwdtzloadData= 62,
    kBusinessTagGetJRcpzrwytz = 63,
    kBusinessTagGetJRcpzrwytz1 = 64,
    kBusinessTagGetJRcpzrwytz1Again = 65,
    kBusinessTagGetJRjrzcjywdsy = 66,
    kBusinessTagGetJRwdtzloadDataAgain= 67,
    kBusinessTagGetJRDetail= 68,
    kBusinessTagGetJRmyJrzcPaging= 69,
    kBusinessTagGetJRmyJrzcPagingAgain= 70,
    kBusinessTagGetJRtransRecordListAgain = 71,
    kBusinessTagGetJRtransRecordListPast= 72,
    kBusinessTagGetJRtransRecordListPastAgain = 73,
    kBusinessTagGetJRFundsListAgain = 74,
    kBusinessTagGetJRFundsListPast = 75,
    kBusinessTagGetJRFundsListPastAgain = 76,
    kBusinessTagGetJRjrzcjywdsyAgain = 77,
    kBusinessTagGetJRcpzrwytzAgain = 78,
    kBusinessTagGetJRcpzrwytzPast = 79,
    kBusinessTagGetJRcpzrwytzPastAgain = 80,
    kBusinessTagGetJRcpzrwytzPast1 = 81,
    kBusinessTagGetJRcpzrwytzPast1Again = 82,
    kBusinessTagGetJRcpzrwytzPast2 = 83,
    kBusinessTagGetJRcpzrwytzPast2Again = 84,
    kBusinessTagGetJRcpzrwyzrloadData = 85,
    kBusinessTagGetJRcpzrwyzrloadDataAgain = 86,
    kBusinessTagGetJRapplyOutMoney = 87,
    kBusinessTagGetJRapplyOutMoneyAgain = 88,
    kBusinessTagGetJRReCharger = 89,
    kBusinessTagGetJRSelling = 90,
    kBusinessTagGetJRIndex = 91,
    kBusinessTagGetJRApplySaveMoneySubmit = 92,
    kBusinessTagGetJRApplyOutMoneySubmit = 93,
    kBusinessTagGetJRDoTrade = 94,//投资专区申报
    kBusinessTagGetJRGetSupBankList = 95,
    kBusinessTagGetJRGetSupBankListAgain = 96,
    kBusinessTagGetJRGetSelling = 97,//我要转让详情页面
    kBusinessTagGetJRsendVcodeBindCard = 98,//发送绑定或解绑信息
    kBusinessTagGetJRbindBankCardSubmit = 99,//绑定
    kBusinessTagGetJRunBindBankCardSubmit = 100,//解绑
    kBusinessTagGetJRapplyOutMoney1 = 101,
    
    kBusinessTagGetJRProvinceData = 102,//获取省份
    kBusinessTagGetJRProvinceDataAgain = 103,
    kBusinessTagGetJRCityData = 104,//获取市区
    kBusinessTagGetJRCityDataAgain = 105,
    kBusinessTagGetJRsmrzSendVcode = 106,//验证码
    kBusinessTagGetJRsmrzRealNameAuthentication = 107,//实名认证
    kBusinessTagGetJRisNeedPsw = 108,//是否需要银行卡密码
    kBusinessTagGetJRstep2 = 109,
    kBusinessTagGetJRsavePWD = 110,//重置交易密码
    kBusinessTagGetJRmodifyTranPwdSubmit = 111,//修改交易密码
    kBusinessTagGetJRmodifyLoginPwdSubmit = 112,//修改登陆密码
    kBusinessTagGetJRupdateUserInfo = 113,//更新用户信息
    kBusinessTagGetJRupdateUserInfoAgain = 114,//更新用户信息
    kBusinessTagGetJRtodayEntrustPage = 115,//当日查询
    kBusinessTagGetJRtodayEntrustPageAgain = 116,
    kBusinessTagGetJRtodayEntrustPage1 = 117,
    kBusinessTagGetJRtodayEntrustPage1Again = 118,
    kBusinessTagGetJRtodayEntrustPage2 = 119,//当日查询
    kBusinessTagGetJRtodayEntrustPage2Again = 120,
    kBusinessTagGetJRtodayEntrustPage3 = 121,
    kBusinessTagGetJRtodayEntrustPage3Again = 122,
    kBusinessTagGetJRentrustWithdraw = 123,
    kBusinessTagGetJRentrustWithdraw1 = 124,
    kBusinessTagGetJRentrustWithdraw2 = 125,
    kBusinessTagGetJRentrustWithdraw3 = 126,
    kBusinessTagGetJRhotproject = 127,
    kBusinessTagGetJRsmrzsendVcode = 128,
    kBusinessTagGetJRbindCardcheckResult = 129,
    kBusinessTagGetJRcpzrdoTrade = 130,//转让专区申报
    kBusinessTagGetJRwyzrdoTrade = 131,// 我要转让申报
    kBusinessTagGetJRinfolist = 132,// 二级菜单列表
    kBusinessTagGetJRinfolistAgain = 133,
    kBusinessTagGetJRinfodetail = 134,//页面内容详情
    kBusinessTagGetJRcarouselImgUrl = 135,//轮播图
    kBusinessTagGetJRregisterdoPersonal = 136,//轮播图
    kBusinessTagGetJRmyCoinmyCoinData = 137,
    kBusinessTagGetJRmyCoinmyCoinDataAgain = 138,
    kBusinessTagGetJRmyCoinmyCoinData1 = 139,
    kBusinessTagGetJRmyCoinmyCoinData1Again = 140,
    kBusinessTagGetJRmyCoinmyCoinData2 = 141,
    kBusinessTagGetJRmyCoinmyCoinData2Again = 142,
    kBusinessTagGetJRDetailAgain= 143,
    kBusinessTagGetJRgetSxf= 144, //获取手续费
    kBusinessTagGetJRuserCoinData= 145,
    kBusinessTagGetJRmyFavoritesData = 146,
    kBusinessTagGetJRmyFavoritesDataAgain = 147,
    kBusinessTagGetJRmyFavoritesDataadd = 148,
    kBusinessTagGetJRmyFavoritesDataremove = 149,
    kBusinessTagGetJRSellingAgain = 150,
    kBusinessTagGetJRinfolist1 = 151,// 二级菜单列表
    kBusinessTagGetJRinfolist1Again = 152,
    kBusinessTagGetJRjrzcjywdsyName = 153,
    kBusinessTagGetJRjrzcjywdsyDate = 154,
    kBusinessTagGetJRprovinceData = 155,//省份
    kBusinessTagGetJRcityData = 156,//地区
    
};
typedef enum kBusinessTag kBusinessTag;

@protocol NetworkModuleDelegate<NSObject>
@required
-(void)beginPost:(kBusinessTag)tag;
-(void)endPost:(NSString*)result business:(kBusinessTag)tag;
-(void)errorPost:(NSError*)err business:(kBusinessTag)tag;
@end