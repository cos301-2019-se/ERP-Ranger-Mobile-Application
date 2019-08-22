import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ReportTypeUpdateComponent } from './report-type-update.component';

describe('ReportTypeUpdateComponent', () => {
  let component: ReportTypeUpdateComponent;
  let fixture: ComponentFixture<ReportTypeUpdateComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ReportTypeUpdateComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ReportTypeUpdateComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
