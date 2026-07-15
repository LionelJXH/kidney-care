/**
 * 体重记录页面
 */
import { insertWeightRecord } from '../common/Database';
import { COLOR_PRIMARY, COLOR_NORMAL, COLOR_WARNING, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_TEXT_HINT, COLOR_CARD, COLOR_PAGE, formatTime } from '../common/Constants';
import router from '@ohos.router';

@Entry
@Component
struct WeightPage {
  @State weight: string = '';
  @State currentTime: string = '';
  @State saved: boolean = false;
  @State errorMsg: string = '';

  aboutToAppear(): void {
    this.currentTime = formatTime(Date.now());
  }

  async saveRecord(): Promise<void> {
    this.errorMsg = '';
    const val: number = parseFloat(this.weight);
    if (isNaN(val) || val <= 0) {
      this.errorMsg = '请输入有效的体重数值';
      return;
    }
    if (val < 20 || val > 300) {
      this.errorMsg = '体重范围：20~300 kg';
      return;
    }
    try {
      await insertWeightRecord({ timestamp: Date.now(), weight: val });
      this.saved = true;
      setTimeout(() => { router.back(); }, 1200);
    } catch (e) {
      this.errorMsg = '保存失败，请重试';
    }
  }

  build() {
    Column() {
      Row() {
        Text('< 返回').fontSize(16).fontColor(COLOR_PRIMARY).onClick(() => { router.back(); })
        Text('记录体重').fontSize(20).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text(' ').fontSize(16).fontColor(COLOR_PRIMARY).width(60)
      }
      .width('100%')
      .padding({ top: 16, bottom: 8, left: 20, right: 20 })

      Scroll() {
        Column() {
          Column() {
            Text('⏱️ 记录时间').fontSize(14).fontColor(COLOR_TEXT_SECONDARY)
            Text(this.currentTime).fontSize(32).fontWeight(FontWeight.Bold).fontColor(COLOR_PRIMARY).margin({ top: 8 })
            Text('系统自动记录当前时刻').fontSize(13).fontColor(COLOR_TEXT_HINT).margin({ top: 4 })
          }
          .width('100%')
          .padding(20)
          .backgroundColor(COLOR_CARD)
          .borderRadius(14)
          .alignItems(HorizontalAlign.Center)

          Column() {
            Text('⚖️ 体重').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY)
            Row() {
              TextInput({ placeholder: '请输入体重', text: this.weight })
                .placeholderColor(COLOR_TEXT_HINT)
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .height(52)
                .layoutWeight(1)
                .type(InputType.Number)
                .onChange((v: string) => { this.weight = v; })
              Text('kg').fontSize(18).fontColor(COLOR_TEXT_SECONDARY).margin({ left: 12 })
            }
            .margin({ top: 12 })
            Text('定期监测体重对肾病管理很重要').fontSize(12).fontColor(COLOR_TEXT_HINT).margin({ top: 4 })
          }
          .width('100%')
          .padding(20)
          .backgroundColor(COLOR_CARD)
          .borderRadius(14)
          .margin({ top: 12 })

          Column() {
            Text('💡 为什么要监测体重？').fontSize(15).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY)
            Text('体重突然增加可能提示水肿/水钠潴留\n体重持续下降需关注营养不良')
              .fontSize(13).fontColor(COLOR_TEXT_SECONDARY).margin({ top: 8 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(COLOR_CARD)
          .borderRadius(14)
          .margin({ top: 12 })

          if (this.errorMsg !== '') {
            Text(this.errorMsg).fontSize(14).fontColor(COLOR_WARNING).margin({ top: 12 })
          }

          Button() {
            Text(this.saved ? '✅ 已保存' : '保存体重').fontSize(18).fontWeight(FontWeight.Bold).fontColor(Color.White)
          }
          .width('100%')
          .height(52)
          .backgroundColor(this.saved ? COLOR_NORMAL : COLOR_PRIMARY)
          .borderRadius(26)
          .margin({ top: 24, bottom: 40 })
          .enabled(!this.saved)
          .onClick(() => { this.saveRecord(); })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 20 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLOR_PAGE)
  }
}
