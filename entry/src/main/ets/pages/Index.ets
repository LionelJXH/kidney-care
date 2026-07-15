/**
 * 首页 - 仪表盘
 */
import { getTodayBpRecords, getLatestWeight, getLatestLabTest } from '../common/Database';
import { formatTime, formatDate, BP_NORMAL_SYS, BP_NORMAL_DIA, COLOR_PRIMARY, COLOR_WARNING, COLOR_NORMAL, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_TEXT_HINT, COLOR_CARD, COLOR_PAGE } from '../common/Constants';
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

  onPageShow(): void {
    this.loadTodayData();
  }

  async loadTodayData(): Promise<void> {
    try {
      const bpRecords = await getTodayBpRecords();
      this.todayBpCount = bpRecords.length;
      if (bpRecords.length > 0) {
        const latest = bpRecords[0];
        this.latestSystolic = latest.systolic;
        this.latestDiastolic = latest.diastolic;
        this.latestBpTime = formatTime(latest.timestamp);
      }
      const weightRecord = await getLatestWeight();
      if (weightRecord) {
        this.latestWeight = weightRecord.weight.toFixed(1);
        this.latestWeightTime = formatTime(weightRecord.timestamp);
      }
      const labTest = await getLatestLabTest();
      if (labTest) {
        this.latestLabDate = formatDate(labTest.timestamp);
        this.latestLabType = labTest.testType === 'blood' ? '血检' : '尿检';
      }
    } catch (e) {
      console.error('loadTodayData error');
    }
  }

  build() {
    Column() {
      Row() {
        Text('🩺 肾康助手')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT_PRIMARY)
      }
      .width('100%')
      .padding({ top: 24, left: 20, bottom: 8 })

      Scroll() {
        Column() {
          // 今日概览卡片
          Column() {
            Text('今日概览').fontSize(18).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY)
            Row() {
              Text('血压记录').fontSize(14).fontColor(COLOR_TEXT_SECONDARY)
              Text(this.todayBpCount + ' 次').fontSize(20).fontWeight(FontWeight.Bold).fontColor(COLOR_PRIMARY)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ top: 12 })

            if (this.todayBpCount > 0) {
              Row() {
                Text('最近 ' + this.latestBpTime).fontSize(13).fontColor(COLOR_TEXT_HINT)
                Text(this.latestSystolic + '/' + this.latestDiastolic + ' mmHg')
                  .fontSize(22)
                  .fontWeight(FontWeight.Bold)
                  .fontColor((this.latestSystolic > BP_NORMAL_SYS || this.latestDiastolic > BP_NORMAL_DIA) ? COLOR_WARNING : COLOR_NORMAL)
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .margin({ top: 8 })
            } else {
              Text('今日还未记录血压').fontSize(14).fontColor(COLOR_TEXT_HINT).margin({ top: 8 })
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor(COLOR_CARD)
          .borderRadius(14)

          // 快捷入口
          Row() {
            Column() {
              Text('❤️').fontSize(32)
              Text('血压').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY).margin({ top: 8 })
              Text(this.todayBpCount > 0 ? ('最近 ' + this.latestSystolic + '/' + this.latestDiastolic) : '点击记录')
                .fontSize(13).fontColor(COLOR_TEXT_HINT).margin({ top: 4 })
            }
            .width('48%')
            .padding(16)
            .backgroundColor(COLOR_CARD)
            .borderRadius(14)
            .alignItems(HorizontalAlign.Center)
            .onClick(() => {
              router.pushUrl({ url: 'pages/BloodPressurePage' });
            })

            Column() {
              Text('⚖️').fontSize(32)
              Text('体重').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY).margin({ top: 8 })
              Text(this.latestWeight !== '--' ? (this.latestWeight + ' kg') : '点击记录')
                .fontSize(13).fontColor(COLOR_TEXT_HINT).margin({ top: 4 })
            }
            .width('48%')
            .padding(16)
            .backgroundColor(COLOR_CARD)
            .borderRadius(14)
            .alignItems(HorizontalAlign.Center)
            .onClick(() => {
              router.pushUrl({ url: 'pages/WeightPage' });
            })
          }
          .width('100%')
          .margin({ top: 12 })
          .justifyContent(FlexAlign.SpaceBetween)

          // 化验记录入口
          Column() {
            Row() {
              Text('🧪').fontSize(28)
              Column() {
                Text('化验记录').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY)
                if (this.latestLabDate !== '') {
                  Text('最近: ' + this.latestLabDate + ' ' + this.latestLabType)
                    .fontSize(13).fontColor(COLOR_TEXT_HINT).margin({ top: 2 })
                } else {
                  Text('记录每月的血检和尿检数据').fontSize(13).fontColor(COLOR_TEXT_HINT).margin({ top: 2 })
                }
              }
              .margin({ left: 12 })
              .layoutWeight(1)
            }
            .width('100%')
            .onClick(() => {
              router.pushUrl({ url: 'pages/LabTestPage' });
            })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(COLOR_CARD)
          .borderRadius(14)
          .margin({ top: 12 })

          // 查看历史记录
          Column() {
            Row() {
              Text('📊').fontSize(28)
              Text('查看历史记录').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY).margin({ left: 12 })
              Text('>').fontSize(18).fontColor(COLOR_TEXT_HINT).layoutWeight(1).textAlign(TextAlign.End)
            }
            .width('100%')
            .onClick(() => {
              router.pushUrl({ url: 'pages/HistoryPage' });
            })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(COLOR_CARD)
          .borderRadius(14)
          .margin({ top: 12 })
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
