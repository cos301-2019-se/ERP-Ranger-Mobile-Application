import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RangerLeaderboardComponent } from './ranger-leaderboard.component';

describe('RangerLeaderboardComponent', () => {
  let component: RangerLeaderboardComponent;
  let fixture: ComponentFixture<RangerLeaderboardComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RangerLeaderboardComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RangerLeaderboardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
