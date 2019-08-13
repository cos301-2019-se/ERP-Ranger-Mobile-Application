import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AddRewardComponent } from './add-reward.component';

describe('AddRewardComponent', () => {
  let component: AddRewardComponent;
  let fixture: ComponentFixture<AddRewardComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AddRewardComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AddRewardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
