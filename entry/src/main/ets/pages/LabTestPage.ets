/**
 * 化验选择页面
 * 选择血检或尿检，然后进入指标填写
 */
import { COLORS } from '../common/Constants';
import { Card } from '../common/Card';
import router from '@ohos.router';

@Entry
@Component
struct LabTestPage {
  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('< 返回')
          .fontSize(16).fontColor(COLORS.primary)
          .onClick(() => { router.back(); })
        Text('化验记录').fontSize(20).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
          .layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(60)
      }
      .padding({ top: 16, bottom: 8, left: 20, right: 20 })
      .width('100%')

      Scroll() {
        Column() {
          Text('选择化验类型')
            .fontSize(16).fontColor(COLORS.textSecondary).margin({ top: 20, bottom: 8 })

          // 血检入口
          Card() {
            Row() {
              Text('🩸').fontSize(40)
              Column() {
                Text('血常规+生化').fontSize(18).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
                Text('肌酐、eGFR、尿素氮、血钾等 10 项').fontSize(13).fontColor(COLORS.textHint).margin({ top: 4 })
              }
              .margin({ left: 16 })
              .layoutWeight(1)
            }
            .padding(20)
            .width('100%')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/LabTestDetailPage',
                params: { testType: 'blood' }
              });
            })
          }
          .width('100%')
          .margin({ top: 12 })

          // 尿检入口
          Card() {
            Row() {
              Text('💧').fontSize(40)
              Column() {
                Text('尿常规').fontSize(18).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
                Text('尿蛋白、潜血、ACR、pH 等 8 项').fontSize(13).fontColor(COLORS.textHint).margin({ top: 4 })
              }
              .margin({ left: 16 })
              .layoutWeight(1)
            }
            .padding(20)
            .width('100%')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/LabTestDetailPage',
                params: { testType: 'urine' }
              });
            })
          }
          .width('100%')
          .margin({ top: 12 })

          // 说明
          Card() {
            Column() {
              Text('📋 填写说明').fontSize(15).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
              Text('• 数值型指标：直接输入化验单上的数值')
                .fontSize(13).fontColor(COLORS.textSecondary).margin({ top: 8 })
              Text('• 定性指标：如"尿蛋白"选择阴性(-)或阳性(+)')
                .fontSize(13).fontColor(COLORS.textSecondary).margin({ top: 4 })
              Text('• 日期默认今天，可修改为实际化验日期')
                .fontSize(13).fontColor(COLORS.textSecondary).margin({ top: 4 })
            }
            .padding(16)
            .width('100%')
          }
          .width('100%')
          .margin({ top: 20 })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 40 })
      }
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .backgroundColor(COLORS.pageBg)
  }
}

