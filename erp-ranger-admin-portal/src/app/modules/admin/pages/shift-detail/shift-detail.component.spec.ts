import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ShiftDetailComponent } from './shift-detail.component';

describe('ShiftDetailComponent', () => {
  let component: ShiftDetailComponent;
  let fixture: ComponentFixture<ShiftDetailComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ShiftDetailComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ShiftDetailComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
