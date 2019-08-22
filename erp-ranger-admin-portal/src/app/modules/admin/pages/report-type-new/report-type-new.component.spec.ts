import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ReportTypeNewComponent } from './report-type-new.component';

describe('ReportTypeNewComponent', () => {
  let component: ReportTypeNewComponent;
  let fixture: ComponentFixture<ReportTypeNewComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ReportTypeNewComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ReportTypeNewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
