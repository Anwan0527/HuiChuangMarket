import { MapComponent, mapCommon, map } from '@kit.MapKit'
import { AsyncCallback } from '@kit.BasicServicesKit'
import { navi } from '@kit.MapKit'
import { Log } from '@abner/log'

// 准备一个自己的业务数据
interface Data {
  origins: mapCommon.LatLng[],
  destination: mapCommon.LatLng,
  waypoints: mapCommon.LatLng[]
}

// 准备模拟数据
const DATA: Data = {
  // 起始点（发货地）
  origins: [{
    longitude: 117.081306, latitude: 36.671745,
  }],
  // 目的地（收货地）
  destination: {
    longitude: 116.343513, latitude: 40.060249
  },
  // 途经点（必要途经点）
  waypoints: [
    { longitude: 114.52939, latitude: 38.050621 }
  ],
}


@Entry
@Component
struct HuaweiMapDemo {
  private mapOption?: mapCommon.MapOptions
  private callback?: AsyncCallback<map.MapComponentController>
  private mapController?: map.MapComponentController
  private mapPolyline?: map.MapPolyline;
  // 折线绘制
  drawMap = async (points: mapCommon.LatLng[]) => {
    // polyline初始化参数
    let polylineOption: mapCommon.MapPolylineOptions = {
      points: points,
      clickable: true,
      startCap: mapCommon.CapStyle.BUTT,
      endCap: mapCommon.CapStyle.BUTT,
      geodesic: false,
      jointType: mapCommon.JointType.BEVEL,
      visible: true,
      width: 10,
      zIndex: 10,
      gradient: false
    }
    // 创建polyline
    if (this.mapController) {
      this.mapPolyline = await this.mapController.addPolyline(polylineOption)
    }
  }

  // 初始化地图
  initMap = () => {
    // 地图初始化参数，设置地图中心点坐标及层级
    this.mapOption = {
      position: {
        target: { longitude: 114.52939, latitude: 38.050621 },
        zoom: 6
      }
    }

    // 地图初始化的回调
    this.callback = async (err, mapController) => {
      if (!err) {
        // 获取地图的控制器类，用来操作地图
        this.mapController = mapController;
        this.mapController.on("mapLoad", () => {
          console.info(`on-mapLoad`);
          this.getRoad()
        })
      }
    }
  }

  // 路径规划
  getRoad = async () => {
    const points: mapCommon.LatLng[] = []
    let params: navi.DrivingRouteParams = {
      origins: DATA.origins,
      destination: DATA.destination,
      waypoints: DATA.waypoints,
      language: "zh_CN"
    };
    try {
      const result = await navi.getDrivingRoutes(params);
      Log.info(result)
      // result处理成drawMap方法需要的对象数组格式
      result.routes.forEach(route => {
        route.steps.forEach(step => {
          step.roads.forEach(road => {
            points.push(road.startLocation)
            points.push(road.endLocation)
          })
        })
      })
      this.drawMap(points)
    } catch (err) {
      console.error(JSON.stringify(err))
    }
  }

  aboutToAppear(): void {
    this.initMap()
  }

  build() {
    Stack() {
      // 调用MapComponent组件初始化地图
      MapComponent({ mapOptions: this.mapOption, mapCallback: this.callback }).width('100%').height('100%');
    }.height('100%')
  }
}