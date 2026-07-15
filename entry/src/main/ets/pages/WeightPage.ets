/**
 * 体重记录页面
 */
import { insertWeightRecord } from '../common/Database';
import { COLORS, formatTime } from '../common/Constants';
import router from '@ohos.router';

@Entry
@Component
struct WeightPage {
  @State weight: string = '';
  @State currentTime: string = '';
  @State saved: boolean = false;
  @State errorMsg: string = '';

  private timeInterval: number = -1;

  aboutToAppear(): void {
    this.updateTime();
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

  async saveRecord(): Promise<void> {
    this.errorMsg = '';
    const val = parseFloat(this.weight);
    if (isNaN(val) || val <= 0) {
      this.errorMsg = '请输入有效的体重数值';
      return;
    }
    if (val < 20 || val > 300) {
      this.errorMsg = '体重范围：20~300 kg';
      return;
    }

    try {
      await insertWeightRecord({
        timestamp: Date.now(),
        weight: val
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
          .fontSize(16).fontColor(COLORS.primary)
          .onClick(() => { router.back(); })
        Text('记录体重').fontSize(20).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
          .layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(60)
      }
      .padding({ top: 16, bottom: 8, left: 20, right: 20 })
      .width('100%')

      Scroll() {
        Column() {
          // 时间显示
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

          // 体重输入
          Card() {
            Column() {
              Text('⚖️ 体重').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
              Row() {
                TextInput({ placeholder: '请输入体重', text: this.weight })
                  .placeholderColor(COLORS.textHint)
                  .fontSize(28)
                  .fontWeight(FontWeight.Bold)
                  .height(52)
                  .layoutWeight(1)
                  .type(InputType.Number)
                  .onChange((v) => { this.weight = v; })
                Text('kg').fontSize(18).fontColor(COLORS.textSecondary).margin({ left: 12 })
              }
              .margin({ top: 12 })
              Text('定期监测体重对肾病管理很重要').fontSize(12).fontColor(COLORS.textHint).margin({ top: 4 })
            }
            .padding(20)
            .width('100%')
          }
          .width('100%')
          .margin({ top: 12 })

          // 提示卡片
          Card() {
            Column() {
              Text('💡 为什么要监测体重？').fontSize(15).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
              Text('体重突然增加可能提示水肿/水钠潴留\n体重持续下降需关注营养不良')
                .fontSize(13).fontColor(COLORS.textSecondary).lineHeight(20).margin({ top: 8 })
            }
            .padding(16)
            .width('100%')
          }
          .width('100%')
          .margin({ top: 12 })

          // 错误
          if (this.errorMsg !== '') {
            Text(this.errorMsg).fontSize(14).fontColor(COLORS.warning).margin({ top: 12 })
          }

          // 保存按钮
          Button() {
            Text(this.saved ? '✅ 已保存' : '保存体重')
              .fontSize(18).fontWeight(FontWeight.Bold).fontColor(Color.White)
          }
          .width('100%').height(52)
          .backgroundColor(this.saved ? COLORS.normal : COLORS.primary)
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
    .width('100%').height('100%')
    .backgroundColor(COLORS.pageBg)
  }
}

@Component
struct Card {
  build() {
    Column() { this.children }
      .backgroundColor(COLORS.cardBg).borderRadius(14)
  }
}
