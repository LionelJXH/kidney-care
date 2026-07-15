/**
 * 历史记录页面
 */
import { getBpRecords, getWeightRecords, getLabTests } from '../common/Database';
import { COLOR_PRIMARY, COLOR_WARNING, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, COLOR_TEXT_HINT, COLOR_CARD, COLOR_PAGE, formatDateTime, formatDate, BpRecord, WeightRecord, LabTestRecord } from '../common/Constants';
import router from '@ohos.router';

@Entry
@Component
struct HistoryPage {
  @State activeTab: number = 0;
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
      console.error('loadData error');
    }
  }

  build() {
    Column() {
      Row() {
        Text('< 返回').fontSize(16).fontColor(COLOR_PRIMARY).onClick(() => { router.back(); })
        Text('📊 历史记录').fontSize(20).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text(' ').fontSize(16).fontColor(COLOR_PRIMARY).width(60)
      }
      .width('100%')
      .padding({ top: 16, bottom: 8, left: 20, right: 20 })

      Row() {
        Text('❤️ 血压').fontSize(14).fontWeight(this.activeTab === 0 ? FontWeight.Bold : FontWeight.Normal).fontColor(this.activeTab === 0 ? COLOR_PRIMARY : COLOR_TEXT_SECONDARY).layoutWeight(1).textAlign(TextAlign.Center).padding({ top: 10, bottom: 4 }).onClick(() => { this.activeTab = 0; })
        Text('⚖️ 体重').fontSize(14).fontWeight(this.activeTab === 1 ? FontWeight.Bold : FontWeight.Normal).fontColor(this.activeTab === 1 ? COLOR_PRIMARY : COLOR_TEXT_SECONDARY).layoutWeight(1).textAlign(TextAlign.Center).padding({ top: 10, bottom: 4 }).onClick(() => { this.activeTab = 1; })
        Text('🧪 化验').fontSize(14).fontWeight(this.activeTab === 2 ? FontWeight.Bold : FontWeight.Normal).fontColor(this.activeTab === 2 ? COLOR_PRIMARY : COLOR_TEXT_SECONDARY).layoutWeight(1).textAlign(TextAlign.Center).padding({ top: 10, bottom: 4 }).onClick(() => { this.activeTab = 2; })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor(COLOR_CARD)
      .margin({ top: 4, left: 20, right: 20 })

      if (this.activeTab === 0) {
        Scroll() {
          Column() {
            if (this.bpRecords.length === 0) {
              Text('暂无血压记录').fontSize(15).fontColor(COLOR_TEXT_HINT).margin({ top: 60 })
            } else {
              ForEach(this.bpRecords, (record: BpRecord) => {
                Column() {
                  Row() {
                    Text(record.systolic.toString()).fontSize(28).fontWeight(FontWeight.Bold).fontColor(record.systolic > 130 ? COLOR_WARNING : COLOR_PRIMARY)
                    Text('/').fontSize(24).fontColor(COLOR_TEXT_SECONDARY).margin({ left: 4, right: 4 })
                    Text(record.diastolic.toString()).fontSize(28).fontWeight(FontWeight.Bold).fontColor(record.diastolic > 85 ? COLOR_WARNING : COLOR_PRIMARY)
                    Text(' mmHg').fontSize(14).fontColor(COLOR_TEXT_SECONDARY).margin({ left: 6 })
                    Text(formatDateTime(record.timestamp)).fontSize(13).fontColor(COLOR_TEXT_HINT).layoutWeight(1).textAlign(TextAlign.End)
                  }
                  .width('100%')
                }
                .width('100%')
                .padding(16)
                .backgroundColor(COLOR_CARD)
                .borderRadius(14)
                .margin({ top: 6 })
              })
            }
          }
          .width('100%')
          .padding({ left: 20, right: 20, bottom: 40 })
        }
        .layoutWeight(1)
      } else if (this.activeTab === 1) {
        Scroll() {
          Column() {
            if (this.weightRecords.length === 0) {
              Text('暂无体重记录').fontSize(15).fontColor(COLOR_TEXT_HINT).margin({ top: 60 })
            } else {
              ForEach(this.weightRecords, (record: WeightRecord) => {
                Column() {
                  Row() {
                    Text('⚖️ ').fontSize(24)
                    Text(record.weight.toFixed(1)).fontSize(28).fontWeight(FontWeight.Bold).fontColor(COLOR_PRIMARY)
                    Text(' kg').fontSize(16).fontColor(COLOR_TEXT_SECONDARY).margin({ left: 4 })
                    Text(formatDateTime(record.timestamp)).fontSize(13).fontColor(COLOR_TEXT_HINT).layoutWeight(1).textAlign(TextAlign.End)
                  }
                  .width('100%')
                }
                .width('100%')
                .padding(16)
                .backgroundColor(COLOR_CARD)
                .borderRadius(14)
                .margin({ top: 6 })
              })
            }
          }
          .width('100%')
          .padding({ left: 20, right: 20, bottom: 40 })
        }
        .layoutWeight(1)
      } else {
        Scroll() {
          Column() {
            if (this.labRecords.length === 0) {
              Text('暂无化验记录').fontSize(15).fontColor(COLOR_TEXT_HINT).margin({ top: 60 })
            } else {
              ForEach(this.labRecords, (record: LabTestRecord) => {
                Column() {
                  Row() {
                    Text(record.testType === 'blood' ? '🩸 血检' : '💧 尿检').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_PRIMARY)
                    Text(formatDate(record.timestamp)).fontSize(14).fontColor(COLOR_TEXT_HINT).layoutWeight(1).textAlign(TextAlign.End)
                  }
                  .width('100%')
                  Text('共 ' + record.items.length + ' 项指标').fontSize(13).fontColor(COLOR_TEXT_HINT).margin({ top: 4 })
                }
                .width('100%')
                .padding(16)
                .backgroundColor(COLOR_CARD)
                .borderRadius(14)
                .margin({ top: 6 })
              })
            }
          }
          .width('100%')
          .padding({ left: 20, right: 20, bottom: 40 })
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLOR_PAGE)
  }
}
