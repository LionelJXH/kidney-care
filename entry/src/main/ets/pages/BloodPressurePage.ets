/**
 * 血压记录页面
 * 手动录入收缩压、舒张压、脉搏，时间自动生成
 */
import { insertBpRecord } from '../common/Database';
import { BP_NORMAL, COLORS, formatTime } from '../common/Constants';
import { Card } from '../common/Card';
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

  private timeInterval: number = -1;

  aboutToAppear(): void {
    this.updateTime();
    // 每秒更新时间
    this.timeInterval = setInterval(() => {
      this.updateTime();
    }, 1000);
  }

  aboutToDisappear(): void {
    if (this.timeInterval > 0) {
      clearInterval(this.timeInterval);
    }
  }

  updateTime(): void {
    this.currentTime = formatTime(Date.now());
  }

  get systolicStatus(): string {
    const val = parseInt(this.systolic);
    if (isNaN(val)) return '';
    return val > BP_NORMAL.systolic.max ? 'high' : 'normal';
  }

  get diastolicStatus(): string {
    const val = parseInt(this.diastolic);
    if (isNaN(val)) return '';
    return val > BP_NORMAL.diastolic.max ? 'high' : 'normal';
  }

  async saveRecord(): Promise<void> {
    this.errorMsg = '';

    const sys = parseInt(this.systolic);
    const dia = parseInt(this.diastolic);

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
      setTimeout(() => {
        router.back();
      }, 1200);
    } catch (e) {
      this.errorMsg = '保存失败，请重试';
    }
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('< 返回')
          .fontSize(16)
          .fontColor(COLORS.primary)
          .onClick(() => { router.back(); })
        Text('记录血压').fontSize(20).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
          .layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(60)
      }
      .padding({ top: 16, bottom: 8, left: 20, right: 20 })
      .width('100%')

      Scroll() {
        Column() {
          // 当前时间卡片
          Card() {
            Column() {
              Text('⏱️ 记录时间').fontSize(14).fontColor(COLORS.textSecondary)
              Text(this.currentTime).fontSize(32).fontWeight(FontWeight.Bold).fontColor(COLORS.primary)
                .margin({ top: 8 })
              Text('系统自动记录当前时刻').fontSize(13).fontColor(COLORS.textHint).margin({ top: 4 })
            }
            .padding(20)
            .width('100%')
            .alignItems(HorizontalAlign.Center)
          }
          .width('100%')

          // 收缩压输入
          Card() {
            Column() {
              Row() {
                Text('❤️ 收缩压 (高压)')
                  .fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
                if (this.systolicStatus === 'high') {
                  Text('⚠️ 偏高').fontSize(12).fontColor(COLORS.warning)
                    .backgroundColor(COLORS.warningLight).borderRadius(8).padding({ left: 8, right: 8, top: 2, bottom: 2 })
                    .margin({ left: 8 })
                }
              }
              Row() {
                TextInput({ placeholder: '收缩压', text: this.systolic })
                  .placeholderColor(COLORS.textHint)
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .height(48)
                  .layoutWeight(1)
                  .type(InputType.Number)
                  .onChange((v) => { this.systolic = v; })
                Text('mmHg').fontSize(16).fontColor(COLORS.textSecondary).margin({ left: 12 })
              }
              .margin({ top: 12 })
              Text('正常范围: 90~130 mmHg').fontSize(12).fontColor(COLORS.textHint).margin({ top: 4 })
            }
            .padding(16)
            .width('100%')
          }
          .width('100%')
          .margin({ top: 12 })

          // 舒张压输入
          Card() {
            Column() {
              Row() {
                Text('💙 舒张压 (低压)')
                  .fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
                if (this.diastolicStatus === 'high') {
                  Text('⚠️ 偏高').fontSize(12).fontColor(COLORS.warning)
                    .backgroundColor(COLORS.warningLight).borderRadius(8).padding({ left: 8, right: 8, top: 2, bottom: 2 })
                    .margin({ left: 8 })
                }
              }
              Row() {
                TextInput({ placeholder: '舒张压', text: this.diastolic })
                  .placeholderColor(COLORS.textHint)
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .height(48)
                  .layoutWeight(1)
                  .type(InputType.Number)
                  .onChange((v) => { this.diastolic = v; })
                Text('mmHg').fontSize(16).fontColor(COLORS.textSecondary).margin({ left: 12 })
              }
              .margin({ top: 12 })
              Text('正常范围: 60~85 mmHg').fontSize(12).fontColor(COLORS.textHint).margin({ top: 4 })
            }
            .padding(16)
            .width('100%')
          }
          .width('100%')
          .margin({ top: 12 })

          // 脉搏输入（可选）
          Card() {
            Column() {
              Text('💓 脉搏 (可选)').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
              Row() {
                TextInput({ placeholder: '脉搏', text: this.pulse })
                  .placeholderColor(COLORS.textHint)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .height(44)
                  .layoutWeight(1)
                  .type(InputType.Number)
                  .onChange((v) => { this.pulse = v; })
                Text('次/分').fontSize(16).fontColor(COLORS.textSecondary).margin({ left: 12 })
              }
              .margin({ top: 12 })
            }
            .padding(16)
            .width('100%')
          }
          .width('100%')
          .margin({ top: 12 })

          // 错误提示
          if (this.errorMsg !== '') {
            Text(this.errorMsg).fontSize(14).fontColor(COLORS.warning).margin({ top: 12 })
          }

          // 保存按钮
          Button() {
            Text(this.saved ? '✅ 已保存' : '保存血压记录')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }
          .width('100%')
          .height(52)
          .backgroundColor(this.saved ? COLORS.normal : COLORS.primary)
          .borderRadius(26)
          .margin({ top: 24, bottom: 40 })
          .enabled(!this.saved)
          .onClick(() => {
            this.saveRecord();
          })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 20 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLORS.pageBg)
  }
}

