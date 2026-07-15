/**
 * 历史记录页面
 * 按时间线展示血压、体重、化验记录
 */
import { getBpRecords, getWeightRecords, getLabTests } from '../common/Database';
import { COLORS, formatDateTime, formatDate, BpRecord, WeightRecord, LabTestRecord, TestRecordItem } from '../common/Constants';
import { Card } from '../common/Card';
import router from '@ohos.router';

@Entry
@Component
struct HistoryPage {
  @State activeTab: number = 0; // 0=血压, 1=体重, 2=化验
  @State bpRecords: BpRecord[] = [];
  @State weightRecords: WeightRecord[] = [];
  @State labRecords: LabTestRecord[] = [];

  aboutToAppear(): void {
    this.loadData();
  }

  onPageShow(): void {
    this.loadData();
  }

  async loadData(): Promise<void> {
    try {
      this.bpRecords = await getBpRecords();
      this.weightRecords = await getWeightRecords(30);
      this.labRecords = await getLabTests(20);
    } catch (e) {
      console.error('loadData error: ' + JSON.stringify(e));
    }
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('< 返回')
          .fontSize(16).fontColor(COLORS.primary)
          .onClick(() => { router.back(); })
        Text('📊 历史记录').fontSize(20).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
          .layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(60)
      }
      .padding({ top: 16, bottom: 8, left: 20, right: 20 })
      .width('100%')

      // Tab 切换
      Row() {
        TabButton({ title: '❤️ 血压', active: this.activeTab === 0, tabClick: () => { this.activeTab = 0; } })
        TabButton({ title: '⚖️ 体重', active: this.activeTab === 1, tabClick: () => { this.activeTab = 1; } })
        TabButton({ title: '🧪 化验', active: this.activeTab === 2, tabClick: () => { this.activeTab = 2; } })
      }
      .width('100%').padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ top: 4, left: 20, right: 20 })

      // 内容
      if (this.activeTab === 0) {
        // 血压历史
        Scroll() {
          Column() {
            if (this.bpRecords.length === 0) {
              Text('暂无血压记录').fontSize(15).fontColor(COLORS.textHint).margin({ top: 60 })
            } else {
              ForEach(this.bpRecords, (record: BpRecord) => {
                Card() {
                  Row() {
                    Text(record.systolic.toString()).fontSize(28).fontWeight(FontWeight.Bold)
                      .fontColor(record.systolic > 130 ? COLORS.warning : COLORS.primary)
                    Text('/').fontSize(24).fontColor(COLORS.textSecondary).margin({ left: 4, right: 4 })
                    Text(record.diastolic.toString()).fontSize(28).fontWeight(FontWeight.Bold)
                      .fontColor(record.diastolic > 85 ? COLORS.warning : COLORS.primary)
                    Text('mmHg').fontSize(14).fontColor(COLORS.textSecondary).margin({ left: 6 })
                    Column() {
                      Text(formatDateTime(record.timestamp)).fontSize(13).fontColor(COLORS.textHint)
                      if (record.pulse > 0) {
                        Text(`脉搏 ${record.pulse} 次/分`).fontSize(13).fontColor(COLORS.textHint)
                      }
                    }
                    .margin({ left: 12 })
                    .layoutWeight(1)
                    .alignItems(HorizontalAlign.End)
                  }
                  .padding(16)
                  .width('100%')
                }
                .width('100%')
                .margin({ top: 6 })
              }, (record: BpRecord) => record.id?.toString() || record.timestamp.toString())
            }
          }
          .padding({ left: 20, right: 20, bottom: 40 })
        }
        .layoutWeight(1)
      } else if (this.activeTab === 1) {
        // 体重历史
        Scroll() {
          Column() {
            if (this.weightRecords.length === 0) {
              Text('暂无体重记录').fontSize(15).fontColor(COLORS.textHint).margin({ top: 60 })
            } else {
              ForEach(this.weightRecords, (record: WeightRecord) => {
                Card() {
                  Row() {
                    Text('⚖️').fontSize(24)
                    Text(record.weight.toFixed(1)).fontSize(28).fontWeight(FontWeight.Bold)
                      .fontColor(COLORS.primary).margin({ left: 12 })
                    Text('kg').fontSize(16).fontColor(COLORS.textSecondary).margin({ left: 4 })
                    Text(formatDateTime(record.timestamp)).fontSize(13).fontColor(COLORS.textHint)
                      .layoutWeight(1).textAlign(TextAlign.End)
                  }
                  .padding(16)
                  .width('100%')
                }
                .width('100%')
                .margin({ top: 6 })
              }, (record: WeightRecord) => record.id?.toString() || record.timestamp.toString())
            }
          }
          .padding({ left: 20, right: 20, bottom: 40 })
        }
        .layoutWeight(1)
      } else {
        // 化验历史
        Scroll() {
          Column() {
            if (this.labRecords.length === 0) {
              Text('暂无化验记录').fontSize(15).fontColor(COLORS.textHint).margin({ top: 60 })
            } else {
              ForEach(this.labRecords, (record: LabTestRecord) => {
                Card() {
                  Column() {
                    Row() {
                      Text(record.testType === 'blood' ? '🩸 血检' : '💧 尿检')
                        .fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLORS.primary)
                      Text(formatDate(record.timestamp)).fontSize(14).fontColor(COLORS.textHint)
                        .layoutWeight(1).textAlign(TextAlign.End)
                    }
                    .width('100%')

                    // 显示化验项目摘要
                    ForEach(record.items.slice(0, 5), (item: TestRecordItem) => {
                      Row() {
                        Text(item.name).fontSize(13).fontColor(COLORS.textSecondary)
                          .layoutWeight(1)
                        Text(item.value + (item.unit ? ' ' + item.unit : ''))
                          .fontSize(13).fontWeight(FontWeight.Bold).fontColor(COLORS.textPrimary)
                      }
                      .width('100%').margin({ top: 4 })
                    }, (item: TestRecordItem) => item.key + item.value)
                    if (record.items.length > 5) {
                      Text(`... 还有 ${record.items.length - 5} 项`)
                        .fontSize(12).fontColor(COLORS.textHint).margin({ top: 4 })
                    }
                  }
                  .padding(16)
                  .width('100%')
                }
                .width('100%')
                .margin({ top: 6 })
              }, (record: LabTestRecord) => record.id?.toString() || record.timestamp.toString())
            }
          }
          .padding({ left: 20, right: 20, bottom: 40 })
        }
        .layoutWeight(1)
      }
    }
    .width('100%').height('100%')
    .backgroundColor(COLORS.pageBg)
  }
}

// Tab 按钮组件
@Component
struct TabButton {
  private title: string = '';
  private active: boolean = false;
  private tabClick: () => void = () => {};

  build() {
    Column() {
      Text(this.title)
        .fontSize(14)
        .fontWeight(this.active ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.active ? COLORS.primary : COLORS.textSecondary)
      if (this.active) {
        Row()
          .width('80%')
          .height(3)
          .backgroundColor(COLORS.primary)
          .borderRadius(2)
          .margin({ top: 4 })
      } else {
        Row()
          .width('80%')
          .height(3)
          .backgroundColor(Color.Transparent)
          .borderRadius(2)
          .margin({ top: 4 })
      }
    }
    .layoutWeight(1)
    .padding({ top: 10, bottom: 4 })
    .onClick(() => {
      this.tabClick();
    })
  }
}


