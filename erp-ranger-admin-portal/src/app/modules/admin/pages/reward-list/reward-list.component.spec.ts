import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RewardListComponent } from './reward-list.component';

describe('RewardListComponent', () => {
  let component: RewardListComponent;
  let fixture: ComponentFixture<RewardListComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RewardListComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RewardListComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
