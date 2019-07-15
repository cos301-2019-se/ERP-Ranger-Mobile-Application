import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ShiftFeedbackComponent } from './shift-feedback.component';

describe('ShiftFeedbackComponent', () => {
  let component: ShiftFeedbackComponent;
  let fixture: ComponentFixture<ShiftFeedbackComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ShiftFeedbackComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ShiftFeedbackComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
