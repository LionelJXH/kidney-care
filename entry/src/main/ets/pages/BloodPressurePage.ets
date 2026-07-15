/**
 * 血压记录页面
 */
import { insertBpRecord } from '../common/Database';
import { BP_NORMAL_SYS, BP_NORMAL_DIA, COLOR_PRIMARY, COLOR_NORMAL, COLOR_WARNING, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_TEXT_HINT, COLOR_CARD, COLOR_PAGE, formatTime } from '../common/Constants';
import router from '@ohos.router';

@Entry
@Component
struct BloodPressurePage {
  @State systolic: string = '';
  @State diastolic: string = '';
  @State pulse: string = '';
  @State currentTime: string = '';
  @State saved: boolean = false;
  @State errorMsg: string = '';

  aboutToAppear(): void {
    this.currentTime = formatTime(Date.now());
  }

  async saveRecord(): Promise<void> {
    this.errorMsg = '';
    const sys: number = parseInt(this.systolic);
    const dia: number = parseInt(this.diastolic);
    if (isNaN(sys) || isNaN(dia)) {
      this.errorMsg = '请填写收缩压和舒张压';
      return;
    }
    if (sys < 50 || sys > 260) {
      this.errorMsg = '收缩压范围：50~260 mmHg';
      return;
    }
    if (dia < 30 || dia > 200) {
      this.errorMsg = '舒张压范围：30~200 mmHg';
      return;
    }
    try {
      await insertBpRecord({
        timestamp: Date.now(),
        systolic: sys,
        diastolic: dia,
        pulse: parseInt(this.pulse) || 0
      });
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
        Text('记录血压').fontSize(20).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text(' ').fontSize(16).fontColor(COLOR_PRIMARY).width(60)
      }
      .width('100%')
      .padding({ top: 16, bottom: 8, left: 20, right: 20 })

      Scroll() {
        Column() {
          // 当前时间
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

          // 收缩压
          Column() {
            Row() {
              Text('❤️ 收缩压 (高压)').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY)
              if (parseInt(this.systolic) > BP_NORMAL_SYS) {
                Text('⚠️ 偏高').fontSize(12).fontColor(COLOR_WARNING).backgroundColor('#FDE8E3').borderRadius(8).padding({ left: 8, right: 8, top: 2, bottom: 2 }).margin({ left: 8 })
              }
            }
            Row() {
              TextInput({ placeholder: '收缩压', text: this.systolic })
                .placeholderColor(COLOR_TEXT_HINT)
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .height(48)
                .layoutWeight(1)
                .type(InputType.Number)
                .onChange((v: string) => { this.systolic = v; })
              Text('mmHg').fontSize(16).fontColor(COLOR_TEXT_SECONDARY).margin({ left: 12 })
            }
            .margin({ top: 12 })
            Text('正常范围: 90~130 mmHg').fontSize(12).fontColor(COLOR_TEXT_HINT).margin({ top: 4 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(COLOR_CARD)
          .borderRadius(14)
          .margin({ top: 12 })

          // 舒张压
          Column() {
            Row() {
              Text('💙 舒张压 (低压)').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY)
              if (parseInt(this.diastolic) > BP_NORMAL_DIA) {
                Text('⚠️ 偏高').fontSize(12).fontColor(COLOR_WARNING).backgroundColor('#FDE8E3').borderRadius(8).padding({ left: 8, right: 8, top: 2, bottom: 2 }).margin({ left: 8 })
              }
            }
            Row() {
              TextInput({ placeholder: '舒张压', text: this.diastolic })
                .placeholderColor(COLOR_TEXT_HINT)
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .height(48)
                .layoutWeight(1)
                .type(InputType.Number)
                .onChange((v: string) => { this.diastolic = v; })
              Text('mmHg').fontSize(16).fontColor(COLOR_TEXT_SECONDARY).margin({ left: 12 })
            }
            .margin({ top: 12 })
            Text('正常范围: 60~85 mmHg').fontSize(12).fontColor(COLOR_TEXT_HINT).margin({ top: 4 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(COLOR_CARD)
          .borderRadius(14)
          .margin({ top: 12 })

          // 脉搏
          Column() {
            Text('💓 脉搏 (可选)').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY)
            Row() {
              TextInput({ placeholder: '脉搏', text: this.pulse })
                .placeholderColor(COLOR_TEXT_HINT)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .height(44)
                .layoutWeight(1)
                .type(InputType.Number)
                .onChange((v: string) => { this.pulse = v; })
              Text('次/分').fontSize(16).fontColor(COLOR_TEXT_SECONDARY).margin({ left: 12 })
            }
            .margin({ top: 12 })
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
            Text(this.saved ? '✅ 已保存' : '保存血压记录').fontSize(18).fontWeight(FontWeight.Bold).fontColor(Color.White)
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
