// 购物车子项类型
export interface Result {
  attrsText: string;
  count: number;
  discount: null;
  id: string;
  isCollect: boolean;
  isEffective: boolean;
  name: string;
  nowOriginalPrice: string;
  nowPrice: string;
  picture: string;
  postFee: number;
  price: string;
  selected: boolean;
  skuId: string;
  specs: string[];
  stock: number;
}

export const mockCartList: Result[] = [
  {
    id: "1750713979015004160",
    skuId: "1751078492730032136",
    name: "MontBell 风暴巡洋舰夹克 女款 LTTQ S 货号:1128617 LTTQ",
    attrsText: "尺寸:XS ",
    specs: [],
    picture: "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/259509/p1.png",
    price: "2332.37",
    nowPrice: "2332.37",
    nowOriginalPrice: "2332.37",
    selected: true,
    stock: 8090,
    count: 1,
    isEffective: true,
    discount: null,
    isCollect: false,
    postFee: 12.00
  },
  {
    id: "1750713978830454784",
    skuId: "1751078502179799044",
    name: "Vivienne Westwood 维维安·韦斯特伍德 混搭格纹超大号开衫 红色系 均码",
    attrsText: "尺寸:均码 ",
    specs: [],
    picture: "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/254839/p1.png",
    price: "3668.14",
    nowPrice: "3668.14",
    nowOriginalPrice: "3668.14",
    selected: true,
    stock: 9939,
    count: 1,
    isEffective: true,
    discount: null,
    isCollect: false,
    postFee: 12.00
  }
]