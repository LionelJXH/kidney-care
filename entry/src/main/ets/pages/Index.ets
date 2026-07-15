/**
 * 首页 - 仪表盘
 * 显示今日概览、快捷入口
 */
import { getTodayBpRecords, getLatestWeight, getLatestLabTest } from '../common/Database';
import { formatTime, formatDate, BP_NORMAL, COLORS } from '../common/Constants';
import { Card } from '../common/Card';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State todayBpCount: number = 0;
  @State latestSystolic: number = 0;
  @State latestDiastolic: number = 0;
  @State latestWeight: string = '--';
  @State latestBpTime: string = '';
  @State latestWeightTime: string = '';
  @State latestLabDate: string = '';
  @State latestLabType: string = '';

  aboutToAppear(): void {
    this.loadTodayData();
  }

  async loadTodayData(): Promise<void> {
    try {
      // 今日血压
      const bpRecords = await getTodayBpRecords();
      this.todayBpCount = bpRecords.length;
      if (bpRecords.length > 0) {
        const latest = bpRecords[0];
        this.latestSystolic = latest.systolic;
        this.latestDiastolic = latest.diastolic;
        this.latestBpTime = formatTime(latest.timestamp);
      }

      // 最新体重
      const weightRecord = await getLatestWeight();
      if (weightRecord) {
        this.latestWeight = weightRecord.weight.toFixed(1);
        this.latestWeightTime = formatTime(weightRecord.timestamp);
      }

      // 最新化验
      const labTest = await getLatestLabTest();
      if (labTest) {
        this.latestLabDate = formatDate(labTest.timestamp);
        this.latestLabType = labTest.testType === 'blood' ? '血检' : '尿检';
      }
    } catch (e) {
      console.error('loadTodayData error: ' + JSON.stringify(e));
    }
  }

  onPageShow(): void {
    this.loadTodayData();
  }

  // 血压是否偏高
  get bpStatus(): string {
    if (this.latestSystolic === 0) return 'normal';
    if (this.latestSystolic > BP_NORMAL.systolic.max || this.latestDiastolic > BP_NORMAL.diastolic.max) {
      return 'high';
    }
    return 'normal';
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text('🩺 肾康助手')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLORS.textPrimary)
      }
      .padding({ top: 24, left: 20, bottom: 8 })
      .width('100%')
      .alignItems(VerticalAlign.Top)

      Scroll() {
        Column() {
          // 今日概览卡片
          Card() {
            Column() {
              Text('今日概览').fontSize(18).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
              Row() {
                Text(`血压记录`).fontSize(14).fontColor(COLORS.textSecondary)
                Text(`${this.todayBpCount} 次`).fontSize(20).fontWeight(FontWeight.Bold)
                  .fontColor(COLORS.primary).margin({ left: 8 })
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .width('100%')
              .margin({ top: 12 })

              if (this.todayBpCount > 0) {
                Row() {
                  Text(`最近 ${this.latestBpTime}`).fontSize(13).fontColor(COLORS.textHint)
                  Text(`${this.latestSystolic}/${this.latestDiastolic} mmHg`)
                    .fontSize(22).fontWeight(FontWeight.Bold)
                    .fontColor(this.bpStatus === 'high' ? COLORS.warning : COLORS.normal)
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .width('100%')
                .margin({ top: 8 })
              } else {
                Text('今日还未记录血压').fontSize(14).fontColor(COLORS.textHint)
                  .margin({ top: 8 })
              }
            }
            .padding(16)
            .width('100%')
          }
          .width('100%')
          .margin({ top: 12 })

          // 快捷录入卡片组
          Row() {
            // 血压录入
            QuickEntryCard({
              icon: '❤️',
              title: '血压',
              subtitle: this.todayBpCount > 0 ? `最近 ${this.latestSystolic}/${this.latestDiastolic}` : '点击记录',
              color: '#E8573A',
              cardClick: () => {
                router.pushUrl({ url: 'pages/BloodPressurePage' });
              }
            })

            // 体重录入
            QuickEntryCard({
              icon: '⚖️',
              title: '体重',
              subtitle: this.latestWeight !== '--' ? `${this.latestWeight} kg` : '点击记录',
              color: '#4A90D9',
              cardClick: () => {
                router.pushUrl({ url: 'pages/WeightPage' });
              }
            })
          }
          .width('100%')
          .margin({ top: 12 })

          // 化验记录入口
          Card() {
            Row() {
              Text('🧪').fontSize(28)
              Column() {
                Text('化验记录').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
                if (this.latestLabDate !== '') {
                  Text(`最近: ${this.latestLabDate} ${this.latestLabType}`).fontSize(13).fontColor(COLORS.textHint).margin({ top: 2 })
                } else {
                  Text('记录每月的血检和尿检数据').fontSize(13).fontColor(COLORS.textHint).margin({ top: 2 })
                }
              }
              .margin({ left: 12 })
              .layoutWeight(1)
            }
            .padding(16)
            .width('100%')
            .onClick(() => {
              router.pushUrl({ url: 'pages/LabTestPage' });
            })
          }
          .width('100%')
          .margin({ top: 12 })

          // 查看历史记录
          Card() {
            Row() {
              Text('📊').fontSize(28)
              Text('查看历史记录').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
                .margin({ left: 12 })
              Text('>').fontSize(18).fontColor(COLORS.textHint)
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .padding(16)
            .width('100%')
            .onClick(() => {
              router.pushUrl({ url: 'pages/HistoryPage' });
            })
          }
          .width('100%')
          .margin({ top: 12 })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 40 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLORS.pageBg)
  }
}

// 快捷录入卡片组件
@Component
struct QuickEntryCard {
  private icon: string = '';
  private title: string = '';
  private subtitle: string = '';
  private color: string = '#4A90D9';
  private cardClick: () => void = () => {};

  build() {
    Column() {
      Text(this.icon).fontSize(32)
      Text(this.title).fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary).margin({ top: 8 })
      Text(this.subtitle).fontSize(13).fontColor(COLORS.textHint).margin({ top: 4 })
    }
    .padding(16)
    .width('48%')
    .backgroundColor(COLORS.cardBg)
    .borderRadius(14)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.cardClick();
    })
  }
}

// 通用卡片容器
