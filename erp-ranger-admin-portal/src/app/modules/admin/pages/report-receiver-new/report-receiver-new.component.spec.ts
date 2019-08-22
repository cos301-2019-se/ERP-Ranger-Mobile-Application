import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ReportReceiverNewComponent } from './report-receiver-new.component';

describe('ReportReceiverNewComponent', () => {
  let component: ReportReceiverNewComponent;
  let fixture: ComponentFixture<ReportReceiverNewComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ReportReceiverNewComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ReportReceiverNewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
