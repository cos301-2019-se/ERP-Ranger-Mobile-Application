import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ShiftNewComponent } from './shift-new.component';

describe('ShiftNewComponent', () => {
  let component: ShiftNewComponent;
  let fixture: ComponentFixture<ShiftNewComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ShiftNewComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ShiftNewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
