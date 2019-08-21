import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RangerRewardsComponent } from './ranger-rewards.component';

describe('RangerRewardsComponent', () => {
  let component: RangerRewardsComponent;
  let fixture: ComponentFixture<RangerRewardsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RangerRewardsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RangerRewardsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
