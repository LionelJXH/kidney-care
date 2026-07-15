/**
 * 化验选择页面
 */
import { COLOR_PRIMARY, COLOR_TEXT_PRIMARY, COLOR_TEXT_HINT, COLOR_CARD, COLOR_PAGE } from '../common/Constants';
import router from '@ohos.router';

@Entry
@Component
struct LabTestPage {
  build() {
    Column() {
      Row() {
        Text('< 返回').fontSize(16).fontColor(COLOR_PRIMARY).onClick(() => { router.back(); })
        Text('化验记录').fontSize(20).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text(' ').fontSize(16).fontColor(COLOR_PRIMARY).width(60)
      }
      .width('100%')
      .padding({ top: 16, bottom: 8, left: 20, right: 20 })

      Scroll() {
        Column() {
          Text('选择化验类型').fontSize(16).fontColor(COLOR_TEXT_HINT).margin({ top: 20, bottom: 8 }).width('100%')

          Column() {
            Row() {
              Text('🩸').fontSize(40)
              Column() {
                Text('血常规+生化').fontSize(18).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY)
                Text('肌酐、eGFR、尿素氮、血钾等 10 项').fontSize(13).fontColor(COLOR_TEXT_HINT).margin({ top: 4 })
              }
              .margin({ left: 16 })
              .layoutWeight(1)
            }
            .width('100%')
            .onClick(() => {
              router.pushUrl({ url: 'pages/LabTestDetailPage', params: { testType: 'blood' } });
            })
          }
          .width('100%')
          .padding(20)
          .backgroundColor(COLOR_CARD)
          .borderRadius(14)

          Column() {
            Row() {
              Text('💧').fontSize(40)
              Column() {
                Text('尿常规').fontSize(18).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY)
                Text('尿蛋白、潜血、ACR、pH 等 8 项').fontSize(13).fontColor(COLOR_TEXT_HINT).margin({ top: 4 })
              }
              .margin({ left: 16 })
              .layoutWeight(1)
            }
            .width('100%')
            .onClick(() => {
              router.pushUrl({ url: 'pages/LabTestDetailPage', params: { testType: 'urine' } });
            })
          }
          .width('100%')
          .padding(20)
          .backgroundColor(COLOR_CARD)
          .borderRadius(14)
          .margin({ top: 12 })

          Column() {
            Text('📋 填写说明').fontSize(15).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY)
            Text('• 数值型指标：直接输入化验单上的数值').fontSize(13).fontColor(COLOR_TEXT_HINT).margin({ top: 8 })
            Text('• 定性指标：如"尿蛋白"选择阴性(-)或阳性(+)').fontSize(13).fontColor(COLOR_TEXT_HINT).margin({ top: 4 })
            Text('• 日期默认今天，可修改为实际化验日期').fontSize(13).fontColor(COLOR_TEXT_HINT).margin({ top: 4 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(COLOR_CARD)
          .borderRadius(14)
          .margin({ top: 20 })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 40 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLOR_PAGE)
  }
}
